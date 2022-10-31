class RemoveCategoryFromNews < ActiveRecord::Migration[6.1]
  def change
    remove_reference :news, :news_category, null: false, foreign_key: true
  end
end
