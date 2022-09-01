class AddTitleandobodyToTrainings < ActiveRecord::Migration[6.1]
  def change
    add_column :trainings, :title, :string, null: false
    add_column :trainings, :body, :text, null: false
    add_column :trainings, :male_speech, :string
    add_column :trainings, :female_speech, :string
  end
end
