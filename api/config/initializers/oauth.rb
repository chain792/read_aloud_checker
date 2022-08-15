TwitterConsumer = OAuth::Consumer.new(
  Rails.application.credentials.dig(:twitter, :api_key),
  Rails.application.credentials.dig(:twitter, :api_key_secret),
  site: "https://api.twitter.com"
)

GoogleClient = OAuth2::Client.new(
  Rails.application.credentials.dig(:google, :client_id),
  Rails.application.credentials.dig(:google, :client_secret),
  {
    site: 'https://oauth2.googleapis.com',
    authorize_url: 'https://accounts.google.com/o/oauth2/auth',
    token_url: '/token'
  }
)
