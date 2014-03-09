class Bill < ActiveRecord::Base
  belongs_to :expense
  belongs_to :account
  belongs_to :place

  serialize :meta, Hash

  validates_presence_of :billed_at
end
