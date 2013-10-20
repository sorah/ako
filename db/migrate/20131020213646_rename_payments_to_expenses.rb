class RenamePaymentsToExpenses < ActiveRecord::Migration
  def change
    rename_table :payments, :expenses
  end
end
