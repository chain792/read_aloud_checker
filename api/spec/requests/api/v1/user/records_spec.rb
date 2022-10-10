require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  let!(:me) { create(:user) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }
  let!(:params) {
    { year: Time.current.year, month: Time.current.month }
  }

  describe 'GET /index' do
    context 'ログイン後' do
      it 'データが返る' do
        get api_v1_user_records_path, params: params, xhr: true, headers: headers
        expect(JSON.parse(body).count).to eq(Time.zone.today.end_of_month.day)
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        get api_v1_user_records_path, params: params, xhr: true
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
