class Place < ActiveRecord::Base
  has_many :expenses
  has_many :bills
end
