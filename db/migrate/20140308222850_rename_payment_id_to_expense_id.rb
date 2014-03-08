class RenamePaymentIdToExpenseId < ActiveRecord::Migration
  def change
    rename_column :bills, :payment_id, :expense_id
  end
end
