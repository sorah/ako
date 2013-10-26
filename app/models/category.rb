class Category < ActiveRecord::Base
  has_many :sub_categories

  serialize :meta, Hash

  validates_presence_of :name
  validates_presence_of :budget

  accepts_nested_attributes_for :sub_categories, allow_destroy: true

  class << self
    def total_budget
      Category.pluck('budget').inject(:+)
    end
  end

  def expenses
    Expense.joins(:sub_category) \
           .where(sub_categories: {category_id: self.id})
  end

  def icon
    attributes["icon"] || 'shopping-cart'
  end

  def icon_class
    "icon-#{self.icon}"
  end
end
