require 'rails_helper'

RSpec.describe 'Voices', type: :request do
  let!(:me) { create(:user) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }

  describe 'POST /create' do
    let(:training) { create(:training) }
    let(:training_by_me) { create(:training, user: me) }
    let(:params) {
      { voice: 'test_voice', training_id: training_by_me.id }
    }
    context 'ログイン後' do
      context '自分の資産の場合' do
        it 'createが成功する' do
          expect{ 
            post api_v1_user_voices_path, params: params, xhr: true, headers: headers 
          }.to change{ Training.find(training_by_me.id).voice }.to('test_voice')
          expect(response).to be_successful
          expect(response).to have_http_status :no_content
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect{ 
            post api_v1_user_voices_path, params: { voice: 'test_voice', training_id: training.id }, xhr: true, headers: headers 
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ 
          post api_v1_user_voices_path, params: params, xhr: true
        }.not_to change{ Training.find(training.id).voice }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'Get /presigned_post' do
    context 'ログイン後' do
      it '成功する' do
        get presigned_post_api_v1_user_voices_path, xhr: true, headers: headers
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get presigned_post_api_v1_user_voices_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /presign' do
    context 'ログイン後' do
      it '成功する' do
        get presign_api_v1_user_voices_path, xhr: true, headers: headers
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get presign_api_v1_user_voices_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
