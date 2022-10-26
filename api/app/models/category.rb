class Category < ApplicationRecord
  has_many :sentence_categories, dependent: :destroy
  has_many :sentences, through: :sentence_categories, source: :sentence

  validates :name, presence: true
end
