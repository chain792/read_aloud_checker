require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  let(:user_sentence) { create(:user_sentence) }
  let(:news_sentence) { create(:news_sentence) }

  describe 'GET /api/v1/sentences' do
    let(:user_sentence_num) { 10 }
    let(:news_sentence_num) { 11 }
    before do
      create_list(:user_sentence, user_sentence_num)
      create_list(:news_sentence, news_sentence_num)
    end

    it 'ユーザーによって作成された英文一覧のデータを返す' do
      get api_v1_sentences_path, params: { type: 'user' }, xhr: true

      expect(JSON.parse(body)['sentences'].count).to eq(user_sentence_num)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end

    it 'ニュースから作成された英文一覧のデータを返す' do
      get api_v1_sentences_path, params: { type: 'news' }, xhr: true

      expect(JSON.parse(body)['sentences'].count).to eq(news_sentence_num)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /api/v1/sentences/:id' do
    it 'ユーザーによって作成された英文のデータを返す' do
      get api_v1_sentence_path(user_sentence), xhr: true

      expect(JSON.parse(body)['sentence']['id']).to eq(user_sentence.id)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end

    it 'ニュースから作成された英文のデータを返す' do
      get api_v1_sentence_path(news_sentence), xhr: true

      expect(JSON.parse(body)['sentence']['id']).to eq(news_sentence.id)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end
  end
end
