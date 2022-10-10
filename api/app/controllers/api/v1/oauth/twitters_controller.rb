class Api::V1::Oauth::TwittersController < ApplicationController
  skip_before_action :authenticate!
  skip_before_action :xhr_request?, only: %i[callback]

  def new
    request_token = TwitterConsumer.get_request_token(oauth_callback: callback_url)

    cookies[:token] = {
      value: request_token.token,
      http_only: true,
      secure: true,
      expires: 1.hour.from_now,
    }
    cookies[:token_secret] = {
      value: request_token.secret,
      http_only: true,
      secure: true,
      expires: 1.hour.from_now,
    }

    render json: request_token.authorize_url(oauth_callback: callback_url)
  end

  def callback
    if params[:denied]
      render html: "<script>if(window.location.href.indexOf('oauth/twitter/callback')>0)window.close()</script>".html_safe
      return
    end

    hash = { oauth_token: cookies[:token], oauth_token_secret: cookies[:token_secret] }
    request_token = OAuth::RequestToken.from_hash(TwitterConsumer, hash)

    access_token = request_token.get_access_token(
      {},
      oauth_token: params[:oauth_token],
      oauth_verifier: params[:oauth_verifier],
    )
    response = TwitterConsumer.request(
      :get,
      '/1.1/account/verify_credentials.json?include_entities=false&skip_status=true&include_email=true',
      access_token,
      { scheme: :query_string },
    )

    user_info = get_user_info(response)

    if user_info[:id]
      user = Authentication.find_or_create_user_from_oauth(
        'twitter',
        user_info,
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

    render html: "<script>if(window.location.href.indexOf('oauth/twitter/callback')>0)window.close()</script>".html_safe
  end

  private

  def callback_url
    "#{ENV.fetch('API_DOMAIN', nil)}/api/v1/oauth/twitter/callback"
  end

  def get_user_info(response)
    case response
    when Net::HTTPSuccess
      raw_info = JSON.parse(response.body)

      user_info = {}
      user_info[:id] = raw_info["id"]
      user_info[:name] = raw_info["name"]
      user_info[:email] = raw_info["email"]
      user_info[:image] = raw_info["profile_image_url_https"].sub('normal', 'bigger')
      user_info
    else
      logger.error "Failed OAuth. Code: #{response.code}"
      {}
    end
  end
end
