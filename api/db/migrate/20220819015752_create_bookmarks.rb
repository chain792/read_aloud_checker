class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sentence, null: false, type: :string, foreign_key: true

      t.timestamps
    end

    add_index :bookmarks, [:user_id, :sentence_id], unique: true
  end
end
