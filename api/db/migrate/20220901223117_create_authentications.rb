class CreateAuthentications < ActiveRecord::Migration[6.1]
  def change
    create_table :authentications do |t|
      t.string :uid
      t.string :provider
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true
  end
end
