class Bill < ActiveRecord::Base
  belongs_to :expense
  belongs_to :account
  belongs_to :place

  serialize :meta, Hash

  validates :billed_at, presence: true
  validates :amount, presence: true

  before_validation do
    self.billed_at ||= Time.now if self.new_record?
  end

  include PlaceNameAccessor

  def expense_candidates
    expenses = Expense.where(
      paid_at: ((billed_at.beginning_of_day - 2.days)..(billed_at.end_of_day + 2.days))
    ).load

    expenses.map! do |expense|
      [CandidationScoreForBillAndExpense.new(self, expense).score, expense]
    end
    expenses.reject! { |score, _| score.nil? }

    expenses.sort_by!(&:first)
    expenses.map!(&:last)

    expenses.to_a
  end
end
