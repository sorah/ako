class SetDefaultValues < ActiveRecord::Migration
  def change
    change_column_default :bills, :name, ''

    change_column_default :categories, :order, 0
    change_column_default :categories, :budget, 0
    change_column_default :categories, :fixed, false

    change_column_default :payments, :comment, ''
    change_column_default :payments, :fixed, false

    change_column_default :sub_categories, :order, 0
  end
end
