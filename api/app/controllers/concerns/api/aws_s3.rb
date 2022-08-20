module Api::AwsS3
  extend ActiveSupport::Concern

  def presigned_post_of_public_bucket(key)
    post = PUBLIC_BUCKET.presigned_post(
      key: "public/uploads/#{key}",
      success_action_status: '201',
      acl: 'private'
    )

    { url: post.url, fields: post.fields }
  end

  def presigned_post_of_private_bucket(key)
    post = PRIVATE_BUCKET.presigned_post(
      key: "private/uploads/#{key}",
      success_action_status: '201',
      acl: 'private'
    )

    { url: post.url, fields: post.fields }
  end

  def presigned_url(key)
    Signer.presigned_url(
      :get_object,
      bucket: Rails.application.credentials.dig(:aws, :private_bucket_name),
      key: key
    )
  end
end
