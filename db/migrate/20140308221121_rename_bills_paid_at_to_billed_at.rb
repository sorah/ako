class RenameBillsPaidAtToBilledAt < ActiveRecord::Migration
  def change
    rename_column :bills, :paid_at, :billed_at
  end
end
