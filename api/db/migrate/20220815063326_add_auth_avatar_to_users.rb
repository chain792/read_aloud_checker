class AddAuthAvatarToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :oauth_avatar, :string
  end
end
