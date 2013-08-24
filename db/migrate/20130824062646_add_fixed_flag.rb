class AddFixedFlag < ActiveRecord::Migration
  def change
    add_column :payments, :fixed, :boolean
    add_column :categories, :fixed, :boolean
  end
end
