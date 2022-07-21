module Api::UserAuthenticator
  extend ActiveSupport::Concern

  def current_user
    return @_current_user if @current_user

    return unless bearer_token

    payload, = User.decode_jwt bearer_token
    @_current_user ||= User.find_by(id: payload['user_id'])
  rescue JWT::ExpiredSignature
    nil
  end

  def authenticate!
    return if current_user

    head :unauthorized
  end

  def bearer_token
    pattern = /^Bearer /
    header = request.headers['Authorization']

    header.gsub(pattern, '') if header&.match(pattern)
  end

  def set_refresh_token_to_cookie(refresh_token)
    cookies[:refresh_token] = {
      value: refresh_token,
      http_only: true
    }
  end
end
