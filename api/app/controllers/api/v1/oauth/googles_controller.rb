class Api::V1::Oauth::GooglesController < ApplicationController
  skip_before_action :authenticate!
  skip_before_action :xhr_request?, only: %i[callback]

  def new
    render json: "#{GoogleClient.auth_code.authorize_url(redirect_uri: callback_url)}&scope=email%20profile%20openid"
  end

  def callback
    access_token = GoogleClient.auth_code.get_token(
      params[:code],
      redirect_uri: callback_url
    )
    response = access_token.get(
      'https://www.googleapis.com/oauth2/v3/userinfo',
      params: { access_token: access_token.token }
    )
    
    case response.status
    when 200
      user_info = JSON.parse(response.body)

      if user_info["email"]
        user = User.find_or_create_from_oauth(
          'google',
          user_info["sub"],
          user_info["name"],
          user_info["email"],
          user_info["picture"]
        )

        if user.valid?
          refresh_token = user.refresh_me!
          set_refresh_token_to_cookie(refresh_token)
        else
          logger.error "Failed to create user. user: #{user.inspect}"
        end
      else
        logger.error "Failed to get user info via OAuth. user_info: #{user_info}"
      end
    else
      logger.error "Failed OAuth. Status: #{response.status}"
    end

    render html: "<script>if(window.location.href.indexOf('oauth/google/callback')>0)window.close()</script>".html_safe
  end

  private

  def callback_url
    "#{ENV['API_DOMAIN']}/api/v1/oauth/google/callback"
  end
end
