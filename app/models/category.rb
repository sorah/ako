# rubocop:disable UselessAssignment
class Category < ActiveRecord::Base
  has_many :sub_categories

  serialize :meta, Hash

  validates_presence_of :name
  validates_presence_of :budget

  accepts_nested_attributes_for :sub_categories, allow_destroy: true

  def variable?
    !fixed?
  end

  class << self
    def total_budget(*args)
      # TODO: adjustable budget
      if 2 <= args.size
        year, month = args[0, 2]
        Category.pluck('budget').inject(:+)
      else
        Category.pluck('budget').inject(:+)
      end
    end
  end

  def base_budget
    self[:budget]
  end

  def budget(*args)
    # TODO: adjustable budget
    year, month = args[0, 2] if 2 <= args.size
    base_budget
  end

  def expenses
    Expense.joins(:sub_category) \
           .where(sub_categories: { category_id: self.id })
  end

  def icon
    attributes['icon'] || 'shopping-cart'
  end

  def icon_class
    "icon-#{self.icon}"
  end
end
