class AddFixedFlag < ActiveRecord::Migration
  def change
    add_column :payments, :fixed, :boolean
    add_column :categories, :fixed, :boolean

    add_index :payments, [:paid_at, :fixed]
  end
end
