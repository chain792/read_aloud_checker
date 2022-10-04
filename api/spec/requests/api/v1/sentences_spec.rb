require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  let(:user_sentence) { create(:user_sentence) }
  let(:news_sentence) { create(:news_sentence) }

  describe 'GET /api/v1/sentences/:id' do
    it '英文のデータを返す' do
      get api_v1_sentence_path(user_sentence), xhr: true

      expect(JSON.parse(body)['sentence']['id']).to eq(user_sentence.id)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end

    it '英文のデータを返す' do
      get api_v1_sentence_path(news_sentence), xhr: true

      expect(JSON.parse(body)['sentence']['id']).to eq(news_sentence.id)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end
  end
end
