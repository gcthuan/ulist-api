class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :normal_size_url
      t.string :medium_size_url
      t.string :small_size_url
      t.integer :width
      t.integer :height
      t.integer :time
      t.integer :content_id
      t.timestamps
    end
  end
end
