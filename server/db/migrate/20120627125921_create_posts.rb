class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.datetime :published_at
      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :published_at
    add_index :posts, :title
  end
end
