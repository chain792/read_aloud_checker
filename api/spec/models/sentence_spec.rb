require 'rails_helper'

RSpec.describe Sentence, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      sentence = build(:user_sentence)
      expect(sentence).to be_valid
      expect(sentence.errors).to be_empty
    end

    it '有効であること' do
      sentence = build(:news_sentence)
      expect(sentence).to be_valid
      expect(sentence.errors).to be_empty
    end

    it 'タイトルがない場合、無効' do
      sentence = build(:user_sentence, title: nil)
      expect(sentence).to be_invalid
      expect(sentence.errors[:title]).to eq ["を入力してください"]
    end

    it '本文がない場合、無効' do
      sentence = build(:user_sentence, body: nil)
      expect(sentence).to be_invalid
      expect(sentence.errors[:body]).to eq ["を入力してください"]
    end
  end
end