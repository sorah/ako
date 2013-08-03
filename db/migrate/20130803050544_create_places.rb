class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :foursquare_venue_id
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
