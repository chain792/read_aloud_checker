class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.references :news_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
