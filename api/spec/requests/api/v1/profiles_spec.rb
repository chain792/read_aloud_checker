require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  let!(:me) { create(:user) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }

  describe 'PATCH /update' do
    let(:params) {
      { user: { name: 'update_name_test' } }
    }
    context 'ログイン後' do
      it 'upfateが成功する' do
        expect { patch api_v1_profile_path, params: params, xhr: true, headers: headers }.to change { User.find(me.id).name }.to('update_name_test')
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { patch api_v1_profile_path, params: params, xhr: true }.not_to change { User.find(me.id).name }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'Get /presigned_post' do
    context 'ログイン後' do
      it '成功する' do
        get presigned_post_api_v1_profile_path, xhr: true, headers: headers
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get presigned_post_api_v1_profile_path, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
