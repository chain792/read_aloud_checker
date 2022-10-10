module AccessToken
  extend ActiveSupport::Concern

  class_methods do
    def decode_jwt(token)
      JWT.decode token, Rails.application.credentials.secret_key_base
    end
  end

  def create_access_token
    payload = { user_id: id, exp: set_expeired_time(:jwt) }
    { token: issue_token(payload),
      expired_time: set_expeired_time(:front) }
  end

  private

  def issue_token(payload)
    JWT.encode payload, Rails.application.credentials.secret_key_base
  end

  def set_expeired_time(target)
    # フロントに渡す有効期限の値は1分の余裕をもたせる
    buffer = target == :jwt ? 0 : 1.minute
    (15.minutes.from_now - buffer).to_i
  end
end
