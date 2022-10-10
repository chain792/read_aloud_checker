require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/v1/login' do
    let(:params) {
      { email: user.email, password: 'password' }
    }
    let(:params_2) {
      { email: user.email, password: 'not_password' }
    }

    it 'ログインが成功する' do
      post api_v1_login_path, params: params, xhr: true
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end

    it 'ログインが失敗する' do
      post api_v1_login_path, params: params_2, xhr: true
      expect(response).not_to be_successful
      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'POST /api/v1/refresh' do
    context 'ログイン後' do
      before do
        cookies[:refresh_token] = user.refresh_me!
      end

      it 'refreshが成功する' do
        post api_v1_refresh_path, xhr: true
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    it 'refreshが失敗する' do
      post api_v1_refresh_path, xhr: true
      expect(response).not_to be_successful
      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'DELETE /api/v1/logout' do
    context 'ログイン後' do
      before do
        cookies[:refresh_token] = user.refresh_me!
      end

      it 'logoutが成功する' do
        delete api_v1_logout_path, xhr: true

        expect(response.cookies.fetch('refresh_token')).to be_nil
        expect(response).to be_successful
        expect(response).to have_http_status :no_content
      end
    end
  end
end
