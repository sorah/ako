class ChangeExpensesToHaveManyBills < ActiveRecord::Migration
  def change
    remove_column :expenses, :bill_id
    add_column :bills, :payment_id, :integer
  end
end
