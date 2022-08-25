class AddVsexToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :listening_sex, :integer, null: false, default: 0
  end
end
