require 'rails_helper'

RSpec.describe ResultWord, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      result_word = build(:result_word)
      expect(result_word).to be_valid
      expect(result_word.errors).to be_empty
    end

    it 'ポジションがない場合、無効' do
      result_word = build(:result_word, position: nil)
      expect(result_word).to be_invalid
      expect(result_word.errors[:position]).to eq ["を入力してください"]
    end
  end
end
