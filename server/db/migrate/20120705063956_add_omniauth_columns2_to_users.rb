class AddOmniauthColumns2ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_token, :string
    add_column :users, :facebook_expires_at, :datetime

    add_index :users, :facebook_expires_at
  end
end
