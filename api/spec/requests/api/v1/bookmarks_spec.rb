require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let!(:me) { create(:user) }
  let!(:sentence) { create(:user_sentence) }
  let!(:bookmarked_sentence) { create(:user_sentence) }
  let!(:headers) { { Authorization: "Bearer #{me.create_access_token[:token]}" } }

  describe 'POST /api/v1/sentences/:sentence_id/bookmark' do
    context 'ログイン後' do
      it 'createが成功する' do
        expect { post api_v1_sentence_bookmark_path(sentence), xhr: true, headers: headers }.to change { Bookmark.count }.by(1)
        expect(response).to be_successful
        expect(response).to have_http_status :no_content
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { post api_v1_sentence_bookmark_path(sentence), xhr: true }.not_to change { Bookmark.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE /api/v1/sentences/:sentence_id/bookmark' do
    context 'ログイン後' do
      context '自分の資産の場合' do
        before do
          create(:bookmark, user: me, sentence: bookmarked_sentence)
        end

        it 'destroyが成功する' do
          expect { delete api_v1_sentence_bookmark_path(bookmarked_sentence), xhr: true, headers: headers }
            .to change { Bookmark.count }.by(-1)
          expect(response).to be_successful
          expect(response).to have_http_status :no_content
        end
      end

      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            delete api_v1_sentence_bookmark_path(sentence), xhr: true, headers: headers
          } .to raise_error(NoMethodError)
            .and not_change { Bookmark.count }
        end
      end
    end

    context 'ログイン前' do
      it 'アクセス制限される' do
        expect { delete api_v1_sentence_bookmark_path(bookmarked_sentence), xhr: true }.not_to change { Bookmark.count }
        expect(response).not_to be_successful
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
