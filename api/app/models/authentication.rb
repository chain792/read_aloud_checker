class Authentication < ApplicationRecord
  mount_uploader :image, AvatarUploader
  belongs_to :user

  def self.find_or_create_user_from_oauth(provider, uid, name, email, image)
    (
      Authentication.find_or_create_by(provider: provider, uid: uid) do |authentication|
        authentication.remote_image_url = image
        user = authentication.build_user
        random_value = SecureRandom.alphanumeric(10)

        # twitterはメールアドレスが登録されていないこともあるため、ダミーのメールアドレスをセットする
        if provider == 'twitter'
          email = "#{provider}_#{uid}@mail.ondoku-star.com"
          user.email_status = 'unset'
        end

        user.name = name
        user.email = email
        user.avatar = authentication.image.filename
        user.password = random_value
        user.password_confirmation = random_value
      end
    ).user
  rescue StandardError
    nil
  end
end
