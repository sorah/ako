class RenameBillsNameToTitle < ActiveRecord::Migration
  def change
    rename_column :bills, :name, :title
  end
end
