require 'rails_helper'

RSpec.describe 'ProfilePasswords', type: :request do
  let!(:me) { create(:user) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }

  describe 'PATCH /update' do
    let(:params) {
      { current_password: 'password', password: 'update_password_test', password_confirmation: 'update_password_test' }
    }
    context 'ログイン後' do
      it 'upfateが成功する' do
        expect{ patch api_v1_profile_password_path, params: params, xhr: true, headers: headers }.to change{ User.find(me.id).crypted_password }
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
      it 'upfateが失敗する' do
        expect{ patch api_v1_profile_password_path, params: { current_password: 'password', password: 'update_password_test', password_confirmation: 'not_update_password_test' }, xhr: true, headers: headers }.not_to change{ User.find(me.id).crypted_password }
        expect(response).not_to be_successful
        expect(response).to have_http_status :bad_request
      end
      it 'upfateが失敗する' do
        expect{ patch api_v1_profile_password_path, params: { current_password: 'not_password', password: 'update_password_test', password_confirmation: 'update_password_test' }, xhr: true, headers: headers }.not_to change{ User.find(me.id).crypted_password }
        expect(response).not_to be_successful
        expect(response).to have_http_status :bad_request
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ patch api_v1_profile_password_path, params: params, xhr: true }.not_to change{ User.find(me.id).crypted_password }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
