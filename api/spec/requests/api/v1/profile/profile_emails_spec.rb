require 'rails_helper'

RSpec.describe 'ProfileEmails', type: :request do
  let!(:me) { create(:user) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }

  describe 'PATCH /update' do
    let(:params) {
      { email: 'update_email_test', password: 'password' }
    }
    context 'ログイン後' do
      it 'upfateが成功する' do
        expect { patch api_v1_profile_email_path, params: params, xhr: true, headers: headers }.to change { User.find(me.id).email }.to('update_email_test')
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end

      it 'upfateが失敗する' do
        expect { patch api_v1_profile_email_path, params: { email: 'update_email_test', password: 'not_password' }, xhr: true, headers: headers }.not_to change { User.find(me.id).email }
        expect(response).not_to be_successful
        expect(response).to have_http_status :bad_request
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { patch api_v1_profile_email_path, params: params, xhr: true }.not_to change { User.find(me.id).email }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
