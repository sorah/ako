class Bill < ActiveRecord::Base
  belongs_to :expense

  serialize :meta, Hash

  validates_presence_of :billed_at
end
