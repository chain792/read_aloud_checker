require 'rails_helper'

RSpec.describe NewsCategory, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      news_category = build(:news_category)
      expect(news_category).to be_valid
      expect(news_category.errors).to be_empty
    end

    it '名前がない場合、無効' do
      news_category = build(:news_category, name: nil)
      expect(news_category).to be_invalid
      expect(news_category.errors[:name]).to eq ["を入力してください"]
    end
  end
end