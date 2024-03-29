class User < ApplicationRecord
  include AccessToken
  include RefreshToken
  authenticates_with_sorcery!

  has_many :sentences, as: :creater, dependent: :destroy
  has_many :trainings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_sentences, through: :bookmarks, source: :sentence
  has_many :authentications, dependent: :destroy

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }

  enum email_status: { unverified: 0, verified: 1, unset: 2 }
  enum role: { general: 0, admin: 1, guest: 2 }
  enum listening_sex: { female: 0, male: 1 }

  def bookmark(sentence)
    bookmark_sentences << sentence
  end

  def unbookmark(sentence)
    bookmarks.find_by(sentence_id: sentence.id).destroy!
  end
end
