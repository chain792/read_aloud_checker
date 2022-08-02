class CreateTrainings < ActiveRecord::Migration[6.1]
  def change
    create_table :trainings, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.references :user, null: false, foreign_key: true
      t.references :sentence, null: false, type: :string, foreign_key: true
      t.string :voice
      t.integer :word_count, null: false

      t.timestamps
    end
  end
end
