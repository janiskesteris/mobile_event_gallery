class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.datetime :uploaded_at
      t.string :etag
      t.string :content_type
      t.string :url
      t.string :photo


      t.timestamps
    end
    add_index :images, :etag, :unique => true
  end
end
