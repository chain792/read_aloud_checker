class Training < ApplicationRecord
  include UuidPk

  belongs_to :user
  belongs_to :sentence
  has_many :result_words, dependent: :destroy

  validates :word_count, presence: true
end
