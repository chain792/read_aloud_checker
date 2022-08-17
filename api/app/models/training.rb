class Training < ApplicationRecord
  include UuidPk

  belongs_to :user
  belongs_to :sentence
  has_many :result_words, dependent: :destroy
  accepts_nested_attributes_for :result_words

  validates :word_count, presence: true

  scope :in_month, ->(year, month) { where(created_at: Time.new(year, month).all_month) }
end
