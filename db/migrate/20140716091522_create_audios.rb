class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string :file_url
      t.float :duration
      t.integer :content_id
      t.timestamps
    end
  end
end
