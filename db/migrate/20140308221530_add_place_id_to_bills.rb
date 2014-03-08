class AddPlaceIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :place_id, :integer
  end
end
