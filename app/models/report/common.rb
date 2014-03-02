class Report
  module Common
    def total_expense
      expenses.pluck(:amount).inject(:+) || 0
    end

    def total_fixed_expense
      expenses.fixed.pluck(:amount).inject(:+) || 0
    end

    def total_variable_expense
      expenses.variable.pluck(:amount).inject(:+) || 0
    end

    def expenses_include_categories(reload = false)
      @_expenses_include_categories = nil if reload
      @_expenses_include_categories ||= \
        self.expenses.includes(:sub_category => :category)
    end

    def categories(reload = false)
      @_categories = nil if reload
      @_categories = CategoriesReport.new(self)
      return @_categories if @_categories

      @_categories = Hash[expenses.group_by { |_| _.category }.map { |category, es|
        [category.id, {
          category: category,
          amount: es.map(&:amount).inject(:+),
          fixed_amount: es.select(&:fixed?).map(&:amount).inject(:+) || 0,
          variable_amount: es.select(&:variable?).map(&:amount).inject(:+) || 0,
          sub_categories: Hash[es.group_by { |_| _.sub_category }.map { |sub_category, _es|
            [sub_category.id, {
              sub_category: sub_category,
              amount: _es.map(&:amount).inject(:+),
              fixed_amount: _es.select(&:fixed?).map(&:amount).inject(:+) || 0,
              variable_amount: _es.select(&:variable?).map(&:amount).inject(:+) || 0,
            }]
          }]
        }]
      }]
    end
  end
end
