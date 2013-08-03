class Category < ActiveRecord::Base
  has_many :sub_categories

  def payments
    # TODO
  end
end
