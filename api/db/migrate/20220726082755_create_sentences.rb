class CreateSentences < ActiveRecord::Migration[6.1]
  def change
    create_table :sentences, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.references :creater, null: false, polymorphic: true
      t.string :title
      t.text :body
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
