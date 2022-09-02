class RemoveUidprovideFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, column: [:provider, :uid], unique: true
    remove_column :users, :uid, :string
    remove_column :users, :provider, :string
    remove_column :users, :oauth_avatar, :string
  end
end
