class RemoveWordCountFromTrainings < ActiveRecord::Migration[6.1]
  def change
    remove_column :trainings, :word_count, :integer, null: false
  end
end
