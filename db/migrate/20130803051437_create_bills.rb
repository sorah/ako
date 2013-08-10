class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :amount
      t.string :name
      t.text :meta
      t.datetime :paid_at
      t.references :account

      t.timestamps
    end
  end
end
