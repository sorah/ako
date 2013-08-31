class Category < ActiveRecord::Base
  has_many :sub_categories

  serialize :meta, Hash

  def payments
    # TODO
  end
end
