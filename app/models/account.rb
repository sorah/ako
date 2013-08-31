class Account < ActiveRecord::Base
  has_many :payments

  serialize :meta, Hash
end
