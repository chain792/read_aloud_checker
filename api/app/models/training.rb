class Training < ApplicationRecord
  include UuidPk

  belongs_to :user
  belongs_to :sentence
  has_many :result_words, dependent: :destroy
  accepts_nested_attributes_for :result_words

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 10000 }

  scope :in_month, ->(year, month) { where(created_at: Time.zone.local(year, month).all_month) }
end
