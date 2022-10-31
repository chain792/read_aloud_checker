class AddThumbnailToSentences < ActiveRecord::Migration[6.1]
  def change
    add_column :sentences, :thumbnail, :string
    add_column :sentences, :word_count, :integer
  end
end
