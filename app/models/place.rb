class Place < ActiveRecord::Base
  has_many :payments
end
