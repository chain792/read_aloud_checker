require 'rails_helper'

RSpec.describe 'Trainings', type: :request do
  let!(:me) { create(:user) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }
  let(:user_training_num) { 10 }
  before do
    create_list(:training, user_training_num, user: me)
  end

  describe 'GET /index' do
    context 'ログイン後' do
      it '音読一覧が返る' do
        get api_v1_user_trainings_path, xhr: true, headers: headers
        expect(JSON.parse(body)['trainings'].count).to eq(user_training_num)
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get api_v1_user_trainings_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST /create' do
    let(:sentence) { create(:user_sentence) }
    let(:params) {
      { training: attributes_for(:training).merge(sentence_id: sentence.id) }
    }
    context 'ログイン後' do
      it 'createが成功する' do
        expect { post api_v1_user_trainings_path, params: params, xhr: true, headers: headers }.to change { Training.count }.by(1)
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { post api_v1_user_trainings_path, params: params, xhr: true }.not_to change { Training.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'Get /show' do
    let!(:training) { create(:training) }
    let!(:training_by_me) { create(:training, user: me) }
    context 'ログイン後' do
      context '自分の資産の場合' do
        it 'データを返す' do
          get api_v1_user_training_path(training_by_me), xhr: true, headers: headers

          expect(JSON.parse(body)['training']['id']).to eq(training_by_me.id)
          expect(response).to be_successful
          expect(response).to have_http_status :ok
        end
      end

      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            get api_v1_user_training_path(training), xhr: true, headers: headers
          } .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get api_v1_user_training_path(training_by_me), xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
