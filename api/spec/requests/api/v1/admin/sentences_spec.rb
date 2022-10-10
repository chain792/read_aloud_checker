require 'rails_helper'

RSpec.describe 'AdminSentences', type: :request do
  let!(:guest) { create(:user) }
  let!(:admin) { create(:user, role: :admin) }
  let!(:headers) { { Authorization: "Bearer #{admin.create_access_token[:token]}" } }

  describe 'GET /index' do
    let(:sentence_num) { 10 }
    before do
      create_list(:user_sentence, sentence_num, creater: guest)
    end
    context 'ログイン後' do
      it '英文一覧が返る' do
        get api_v1_admin_sentences_path, xhr: true, headers: headers
        expect(JSON.parse(body)['sentences'].count).to eq(sentence_num)
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get api_v1_admin_sentences_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'ゲストユーザー' do
      let!(:headers) { { Authorization: "Bearer #{guest.create_access_token[:token]}" } }
      it 'アクセス制限される' do
        get api_v1_admin_sentences_path, xhr: true, headers: headers
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PATCH /update' do
    let!(:sentence) { create(:user_sentence) }
    let(:params) {
      { sentence: { body: 'request_test_body' } } 
    }
    context 'ログイン後' do
      it 'upfateが成功する' do
        expect{ patch api_v1_admin_sentence_path(sentence), params: params, xhr: true, headers: headers }.to change{ Sentence.find(sentence.id).body }.to('request_test_body')
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ patch api_v1_admin_sentence_path(sentence), params: params, xhr: true }.not_to change{ Sentence.find(sentence.id).body }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'ゲストユーザー' do
      let!(:headers) { { Authorization: "Bearer #{guest.create_access_token[:token]}" } }
      it 'アクセス制限される' do
        expect{ patch api_v1_admin_sentence_path(sentence), params: params, xhr: true }.not_to change{ Sentence.find(sentence.id).body }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:sentence) { create(:user_sentence) }
    context 'ログイン後' do
      it 'destroyが成功する' do
        expect{ delete api_v1_admin_sentence_path(sentence), xhr: true, headers: headers }.to change{ Sentence.count }.by(-1)
        expect(response).to be_successful
        expect(response).to have_http_status :no_content
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ delete api_v1_admin_sentence_path(sentence), xhr: true }.to change{ Sentence.count }.by(0)
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'ゲストユーザー' do
      let!(:headers) { { Authorization: "Bearer #{guest.create_access_token[:token]}" } }
      it 'アクセス制限される' do
        expect{ delete api_v1_admin_sentence_path(sentence), xhr: true }.to change{ Sentence.count }.by(0)
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
