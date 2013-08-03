class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.reference :place
      t.integer :amount
      t.text :comment
      t.text :meta
      t.datetime :paid_at
      t.reference :subcategory
      t.reference :bill
      t.reference :account

      t.timestamps
    end
  end
end
