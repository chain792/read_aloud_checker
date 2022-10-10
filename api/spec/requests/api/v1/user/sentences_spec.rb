require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  let!(:me) { create(:user) }
  let!(:sentence) { create(:user_sentence) }
  let!(:sentence_by_me) { create(:user_sentence, creater: me) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }
  let(:user_sentence_num) { 10 }
  before do
    create_list(:user_sentence, user_sentence_num, creater: me)
  end

  describe 'GET /index' do
    context 'ログイン後' do
      it '英文一覧が返る' do
        get api_v1_user_sentences_path, xhr: true, headers: headers
        expect(JSON.parse(body)['sentences'].count).to eq(user_sentence_num + 1)
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get api_v1_user_sentences_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST /create' do
    let(:params) {
      { sentence: attributes_for(:user_sentence) }
    }
    context 'ログイン後' do
      it 'createが成功する' do
        expect { post api_v1_user_sentences_path, params: params, xhr: true, headers: headers }.to change { Sentence.count }.by(1)
        expect(response).to be_successful
        expect(response).to have_http_status :no_content
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { post api_v1_user_sentences_path, params: params, xhr: true }.not_to change { Sentence.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /edit' do
    context 'ログイン後' do
      context '自分の資産の場合' do
        it '英文のデータを返す' do
          get edit_api_v1_user_sentence_path(sentence_by_me), xhr: true, headers: headers
          expect(JSON.parse(body)['sentence']['id']).to eq(sentence_by_me.id)
          expect(response).to be_successful
          expect(response).to have_http_status :ok
        end
      end

      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect { get edit_api_v1_user_sentence_path(sentence), xhr: true, headers: headers }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get edit_api_v1_user_sentence_path(sentence_by_me), xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PATCH /update' do
    let(:params) {
      { sentence: { body: 'request_test_body' } }
    }
    context 'ログイン後' do
      context '自分の資産の場合' do
        it 'upfateが成功する' do
          expect { patch api_v1_user_sentence_path(sentence_by_me), params: params, xhr: true, headers: headers }.to change { Sentence.find(sentence_by_me.id).body }.to('request_test_body')
          expect(response).to be_successful
          expect(response).to have_http_status :no_content
        end
      end

      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            patch api_v1_user_sentence_path(sentence), params: params, xhr: true, headers: headers
          } .to raise_error(ActiveRecord::RecordNotFound)
            .and not_change { Sentence.find(sentence_by_me.id).body }
        end
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { patch api_v1_user_sentence_path(sentence_by_me), params: params, xhr: true }.not_to change { Sentence.find(sentence_by_me.id).body }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'ログイン後' do
      context '自分の資産の場合' do
        it 'destroyが成功する' do
          expect { delete api_v1_user_sentence_path(sentence_by_me), xhr: true, headers: headers }.to change { Sentence.count }.by(-1)
          expect(response).to be_successful
          expect(response).to have_http_status :no_content
        end
      end

      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            delete sentence_path(sentence), xhr: true, headers: headers
          } .to raise_error(NoMethodError)
            .and change { Sentence.count }.by(0)
        end
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { delete api_v1_user_sentence_path(sentence_by_me), xhr: true }.not_to change { Sentence.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
