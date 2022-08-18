class RenameWordColumnToResultWords < ActiveRecord::Migration[6.1]
  def change
    remove_column :result_words, :word, :string
    add_column :result_words, :position, :integer, null: false
    add_column :result_words, :result, :integer, null: false, default: 0
  end
end
