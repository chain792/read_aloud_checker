module Api::PresignedPost
  extend ActiveSupport::Concern

  def presigned_post(key)
    post = S3_BUCKET.presigned_post(
      key: "uploads/#{key}",
      success_action_status: '201',
      acl: 'public-read'
    )

    { url: post.url, fields: post.fields }
  end
end
