class CreateResultWords < ActiveRecord::Migration[6.1]
  def change
    create_table :result_words do |t|
      t.references :training, null: false, type: :string, foreign_key: true
      t.string :word, null: false

      t.timestamps
    end
  end
end
