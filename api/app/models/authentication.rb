class Authentication < ApplicationRecord
  mount_uploader :image, AvatarUploader
  belongs_to :user

  def self.find_or_create_user_from_oauth(provider, user_info)
    (
      Authentication.find_or_create_by(provider: provider, uid: user_info[:id]) do |authentication|
        authentication.remote_image_url = user_info[:image]
        user = authentication.build_user
        random_value = SecureRandom.alphanumeric(10)

        # twitterはメールアドレスが登録されていないこともあるため、ダミーのメールアドレスをセットする
        if provider == 'twitter'
          user.email = "#{provider}_#{user_info[:id]}@mail.ondoku-star.com"
          user.email_status = 'unset'
        else
          user.email = user_info[:email]
        end

        user.name = user_info[:name]
        user.avatar = authentication.image.filename
        user.password = random_value
        user.password_confirmation = random_value
      end
    ).user
  rescue StandardError
    nil
  end
end
