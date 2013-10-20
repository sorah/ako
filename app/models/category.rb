class Category < ActiveRecord::Base
  has_many :sub_categories

  serialize :meta, Hash

  validates_presence_of :name
  validates_presence_of :budget

  accepts_nested_attributes_for :sub_categories, allow_destroy: true

  def payments
    Payment.joins(:sub_category) \
           .where(sub_categories: {category_id: self.id})
  end

  def icon
    attributes["icon"] || 'shopping-cart'
  end

  def icon_class
    "icon-#{self.icon}"
  end
end
