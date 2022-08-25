class User < ApplicationRecord
  include AccessToken
  include RefreshToken
  mount_uploader :oauth_avatar, AvatarUploader
  authenticates_with_sorcery!

  has_many :sentences, as: :creater, dependent: :destroy
  has_many :trainings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_sentences, through: :bookmarks, source: :sentence

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }

  enum role: { general: 0, admin: 1, guest: 2 }
  enum listening_sex: { female: 0, male: 1 }

  def self.find_or_create_from_oauth(provider, uid, name, email, image)
    random_value = SecureRandom.alphanumeric(10)

    User.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      user.email = email
      user.remote_oauth_avatar_url = image
      user.avatar = user.oauth_avatar.filename
      user.password = random_value
      user.password_confirmation = random_value
    end
  end

  def bookmark(sentence)
    bookmark_sentences << sentence
  end

  def unbookmark(sentence)
    bookmarks.find_by(sentence_id: sentence.id).destroy!
  end
end
