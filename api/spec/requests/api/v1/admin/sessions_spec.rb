require 'rails_helper'

RSpec.describe 'AdminSessions', type: :request do
  describe 'POST /api/v1/login' do
    let(:params) {
      { email: user.email, password: 'password' }
    }
    let(:params_2) {
      { email: user.email, password: 'not_password' }
    }

    context '管理者' do
      let(:user) { create(:user, role: :admin) }

      it 'ログインが成功する' do
        post api_v1_admin_login_path, params: params, xhr: true
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end

      it 'ログインが失敗する' do
        post api_v1_admin_login_path, params: params_2, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'ゲストユーザー' do
      let(:user) { create(:user) }

      it 'ログインが失敗する' do
        post api_v1_admin_login_path, params: params, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
