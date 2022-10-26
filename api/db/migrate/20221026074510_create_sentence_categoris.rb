class CreateSentenceCategoris < ActiveRecord::Migration[6.1]
  def change
    create_table :sentence_categories do |t|
      t.references :sentence, null: false, type: :string, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
