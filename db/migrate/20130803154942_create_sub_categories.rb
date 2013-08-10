class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.references :category
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
