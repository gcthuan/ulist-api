class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :thumbnail_url
      t.string :seller
      t.string :phone_number
      t.string :price
      t.string :location
      t.timestamps
    end
  end
end
