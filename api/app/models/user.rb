class User < ApplicationRecord
  include AccessToken
  include RefreshToken
  authenticates_with_sorcery!

  has_many :sentences, as: :creater, dependent: :destroy

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 16 }

  enum role: { general: 0, admin: 1, guest: 2 }
end
