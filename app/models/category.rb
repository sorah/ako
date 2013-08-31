class Category < ActiveRecord::Base
  has_many :sub_categories

  serialize :meta, Hash

  validates_presence_of :name
  validates_presence_of :budget

  def payments
    # TODO
  end
end
