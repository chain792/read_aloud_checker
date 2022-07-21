module AccessToken
  extend ActiveSupport::Concern

  class_methods do
    def decode_jwt(token)
      JWT.decode token, Rails.application.secrets.secret_key_base
    end
  end

  def create_access_token
    payload = { user_id: id }
    issue_token(payload.merge(exp: (Time.current + 30.minutes).to_i))
  end

  private

  def issue_token(payload)
    JWT.encode payload, Rails.application.secrets.secret_key_base
  end
end
