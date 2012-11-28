class AddSharedOnTwitterToImages < ActiveRecord::Migration
  def change
    add_column :images, :shared_on_twitter, :boolean, default: false
  end
end
