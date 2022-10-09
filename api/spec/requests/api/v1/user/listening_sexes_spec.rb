require 'rails_helper'

RSpec.describe 'ListeningSexes', type: :request do
  let!(:me) { create(:user, listening_sex: :female) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }


  describe 'PATCH /update' do
    let(:params) {
      { user: { listening_sex: 'male' } } 
    }
    context 'ログイン後' do
      it 'upfateが成功する' do
        expect{ patch api_v1_user_listening_sex_path, params: params, xhr: true, headers: headers }.to change{ User.find(me.id).listening_sex }.to('male')
        expect(response).to be_successful
        expect(response).to have_http_status :no_content
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ patch api_v1_user_listening_sex_path, params: params, xhr: true }.not_to change{ User.find(me.id).listening_sex }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
