class CreateSentences < ActiveRecord::Migration[6.1]
  def change
    create_table :sentences, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.references :creater, null: false, polymorphic: true
      t.string :title, null: false
      t.text :body, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
