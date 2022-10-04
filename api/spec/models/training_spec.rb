require 'rails_helper'

RSpec.describe Training, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      training = build(:training)
      expect(training).to be_valid
      expect(training.errors).to be_empty
    end

    it '有効であること' do
      training = build(:training)
      expect(training).to be_valid
      expect(training.errors).to be_empty
    end

    it 'タイトルがない場合、無効' do
      training = build(:training, title: nil)
      expect(training).to be_invalid
      expect(training.errors[:title]).to eq ["を入力してください"]
    end

    it '本文がない場合、無効' do
      training = build(:training, body: nil)
      expect(training).to be_invalid
      expect(training.errors[:body]).to eq ["を入力してください"]
    end
  end
end