class AddOnLineUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :on_line, :integer, default: 0
  end
end
