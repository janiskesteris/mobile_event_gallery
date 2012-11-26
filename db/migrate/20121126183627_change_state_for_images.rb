class ChangeStateForImages < ActiveRecord::Migration
  def up
    change_column :images, :state, :string, default: "pending"
  end

  def down
    change_column :images, :state, :string, default: nil
  end
end
