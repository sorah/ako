class Payment < ActiveRecord::Base
  has_one :bill
  belongs_to :subcategory
  belongs_to :place
  belongs_to :account

  def category
    # TODO
  end
end
