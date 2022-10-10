require 'rails_helper'

RSpec.describe News, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      news = build(:news)
      expect(news).to be_valid
      expect(news.errors).to be_empty
    end

    it 'タイトルがない場合、無効' do
      news = build(:news, title: nil)
      expect(news).to be_invalid
      expect(news.errors[:title]).to eq ["を入力してください"]
    end
  end
end
