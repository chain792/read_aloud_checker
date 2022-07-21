module RefreshToken
  extend ActiveSupport::Concern

  class_methods do
    def load_from_refresh_token(token)
      # load_from_tokenはsorceryのメソッド
      user = load_from_token(token, :refresh_token, :refresh_token_expires_at)
    end
  end

  def generate_refresh_token
    self.refresh_token = SecureRandom.uuid
    self.save
  end
end
