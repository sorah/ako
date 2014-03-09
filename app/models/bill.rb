class Bill < ActiveRecord::Base
  belongs_to :expense
  belongs_to :account
  belongs_to :place

  serialize :meta, Hash

  validates_presence_of :billed_at
  validates_presence_of :amount

  before_validation do
    if self.new_record?
      self.billed_at ||= Time.now
    end
  end
end
