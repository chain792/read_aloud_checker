class CreateResultWords < ActiveRecord::Migration[6.1]
  def change
    create_table :result_words, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.references :training, null: false, type: :string, foreign_key: true
      t.string :word, null: false

      t.timestamps
    end
  end
end
