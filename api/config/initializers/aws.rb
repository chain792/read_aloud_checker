Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(
    Rails.application.credentials.dig(:aws, :access_key_id),
    Rails.application.credentials.dig(:aws, :secret_access_key)
  )
})

PUBLIC_BUCKET = Aws::S3::Resource.new.bucket(
  Rails.application.credentials.dig(:aws, :public_bucket_name)
)
PRIVATE_BUCKET = Aws::S3::Resource.new.bucket(
  Rails.application.credentials.dig(:aws, :private_bucket_name)
)
Signer = Aws::S3::Presigner.new

Polly = Aws::Polly::Client.new
