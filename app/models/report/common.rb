# rubocop:disable Blocks

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

    def categories(reload = false)
      @_categories = nil if reload
      return @_categories if @_categories

      expenses = self.expenses.includes(sub_category: :category)
      @_categories = Hash[expenses.group_by(&:category).map { |category, es|
        category(category, es)
      }]
    end

    private

    def category(category, es = category.expenses)
      [category.id, {
        category: category,
        amount: es.map(&:amount).inject(:+),
        fixed_amount: es.select(&:fixed?).map(&:amount).inject(:+) || 0,
        variable_amount: es.select(&:variable?).map(&:amount).inject(:+) || 0,
        sub_categories: sub_categories(es),
      }]
    end

    def sub_categories(expenses)
      Hash[expenses.group_by { |_| _.sub_category }.map { |sub_category, es|
        [sub_category.id, {
          sub_category: sub_category,
          amount: es.map(&:amount).inject(:+),
          fixed_amount: es.select(&:fixed?).map(&:amount).inject(:+) || 0,
          variable_amount: es.select(&:variable?).map(&:amount).inject(:+) || 0,
        }]
      }]
    end
  end
end
