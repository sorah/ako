class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :icon
      t.text :meta

      t.timestamps
    end
  end
end
