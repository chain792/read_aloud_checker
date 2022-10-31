class ChangeNewsCategoriesToCategories < ActiveRecord::Migration[6.1]
  def change
    rename_table :news_categories, :categories
  end
end
