require 'rails_helper'

RSpec.describe 'AdminUsers', type: :request do
  let!(:guest) { create(:user) }
  let!(:admin) { create(:user, role: :admin) }
  let!(:headers) { { Authorization: "Bearer #{admin.create_access_token[:token]}" } }

  describe 'GET /index' do
    let(:user_num) { 10 }
    before do
      create_list(:user, user_num)
    end

    context 'ログイン後' do
      it 'ユーザー一覧が返る' do
        get api_v1_admin_users_path, xhr: true, headers: headers
        expect(JSON.parse(body)['users'].count).to eq(user_num + 2)
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get api_v1_admin_users_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'ゲストユーザー' do
      let!(:headers) { { Authorization: "Bearer #{guest.create_access_token[:token]}" } }
      it 'アクセス制限される' do
        get api_v1_admin_users_path, xhr: true, headers: headers
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PATCH /update' do
    let!(:user) { create(:user) }
    let(:params) {
      { user: { name: 'request_test_name' } }
    }
    context 'ログイン後' do
      it 'upfateが成功する' do
        expect { patch api_v1_admin_user_path(user), params: params, xhr: true, headers: headers }.to change { User.find(user.id).name }.to('request_test_name')
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { patch api_v1_admin_user_path(user), params: params, xhr: true }.not_to change { User.find(user.id).name }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'ゲストユーザー' do
      let!(:headers) { { Authorization: "Bearer #{guest.create_access_token[:token]}" } }
      it 'アクセス制限される' do
        expect { patch api_v1_admin_user_path(user), params: params, xhr: true, headers: headers }.not_to change { User.find(user.id).name }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { create(:user) }
    context 'ログイン後' do
      it 'destroyが成功する' do
        expect { delete api_v1_admin_user_path(user), xhr: true, headers: headers }.to change { User.count }.by(-1)
        expect(response).to be_successful
        expect(response).to have_http_status :no_content
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { delete api_v1_admin_user_path(user), xhr: true }.not_to change { User.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'ゲストユーザー' do
      let!(:headers) { { Authorization: "Bearer #{guest.create_access_token[:token]}" } }
      it 'アクセス制限される' do
        expect { delete api_v1_admin_user_path(user), xhr: true, headers: headers }.not_to change { User.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
