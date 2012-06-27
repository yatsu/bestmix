class DropTasks < ActiveRecord::Migration
  def up
    drop_table :tasks
  end

  def down
    create_table "tasks", :force => true do |t|
      t.string   "name"
      t.datetime "created_at",                    :null => false
      t.datetime "updated_at",                    :null => false
      t.integer  "user_id"
      t.boolean  "public",     :default => false, :null => false
    end

    add_index "tasks", ["public"], :name => "index_tasks_on_public"
    add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"
  end
end
