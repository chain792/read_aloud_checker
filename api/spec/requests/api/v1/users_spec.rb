require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/v1/users' do
    let(:params) {
      { user: attributes_for(:user) }
    }

    it 'ユーザーが追加される' do
      expect{ post api_v1_users_path, params: params, xhr: true }.to change{ User.count }.by(1)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /api/v1/users/:id' do
    it 'ユーザーのデータを返す' do
      get api_v1_user_path(user), xhr: true

      expect(JSON.parse(body)['user']['id']).to eq(user.id)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
    end
  end
end
