class AddStateToImages < ActiveRecord::Migration
  def change
    add_column :images, :state, :string
    add_index :images, :state
  end

end
