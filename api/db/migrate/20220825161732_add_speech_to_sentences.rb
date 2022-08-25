class AddSpeechToSentences < ActiveRecord::Migration[6.1]
  def change
    add_column :sentences, :male_speech, :string
    add_column :sentences, :female_speech, :string
  end
end
