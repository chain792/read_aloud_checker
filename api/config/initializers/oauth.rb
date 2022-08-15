TwitterConsumer = OAuth::Consumer.new(
  Rails.application.credentials.dig(:twitter, :api_key),
  Rails.application.credentials.dig(:twitter, :api_key_secret),
  site: "https://api.twitter.com"
)