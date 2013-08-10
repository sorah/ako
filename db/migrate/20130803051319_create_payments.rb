class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.text :comment
      t.text :meta
      t.datetime :paid_at
      t.references :place
      t.references :subcategory
      t.references :bill
      t.references :account

      t.timestamps
    end
  end
end
