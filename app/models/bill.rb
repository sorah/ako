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
      next if self.account_id && expense.account_id && expense.account_id != self.account_id
      next if self.place_id && expense.place_id && expense.place_id != self.place_id

      same_place = self.place_id && expense.place_id == self.place_id
      same_account = self.account_id && expense.account_id == self.account_id
      same_date = expense.paid_at.to_date == self.billed_at.to_date

      same_amount = self.amount == expense.amount
      near_amount = (same_place || same_date) && (self.amount - expense.amount).abs <= (self.amount * 0.05)

      next unless near_amount || same_amount
      next unless self.place_id.nil?    || self.account_id.nil? \
               || expense.place_id.nil? || expense.account_id.nil? \
               || same_place || same_account
      next if !(same_place || same_account) && (near_amount || same_amount) && !same_date

      score = 0
      score -= 100 if same_date
      score -= 230 if same_place
      score -= 120 if same_account
      if same_amount
        score -= 100
      elsif near_amount
        score -= 50
      end

      [score, expense]
    end
    expenses.compact!

    expenses.sort_by!(&:first)
    expenses.map!(&:last)

    expenses.to_a
  end
end
