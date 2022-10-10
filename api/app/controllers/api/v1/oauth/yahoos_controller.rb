class Api::V1::Oauth::YahoosController < ApplicationController
  skip_before_action :authenticate!
  skip_before_action :xhr_request?, only: %i[callback]

  def new
    render json: "#{YahooClient.auth_code.authorize_url(redirect_uri: callback_url)}&scope=email%20profile%20openid"
  end

  def callback
    access_token = YahooClient.auth_code.get_token(
      params[:code],
      redirect_uri: callback_url,
    )
    response = access_token.get(
      'https://userinfo.yahooapis.jp/yconnect/v2/attribute',
    )

    case response.status
    when 200
      user_info = JSON.parse(response.body)

      if user_info["email"]
        user = Authentication.find_or_create_user_from_oauth(
          'yahoo',
          user_info["sub"],
          user_info["nickname"],
          user_info["email"],
          user_info["picture"],
        )

        if user&.valid?
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

    render html: "<script>if(window.location.href.indexOf('oauth/yahoo/callback')>0)window.close()</script>".html_safe
  end

  private

  def callback_url
    "#{ENV.fetch('API_DOMAIN', nil)}/api/v1/oauth/yahoo/callback"
  end
end
