class AddUserIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user_id, :integer
    add_column :tasks, :public, :boolean, :null => false, :default => false

    add_index :tasks, :user_id
    add_index :tasks, :public
  end
end
