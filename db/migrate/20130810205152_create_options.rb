class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :tag
      t.binary :val

      t.timestamps
    end
  end
end
