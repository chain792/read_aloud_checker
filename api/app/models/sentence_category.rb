class SentenceCategory < ApplicationRecord
  belongs_to :category
  belongs_to :sentence

  validates :category_id, uniqueness: { scope: :sentence_id }
end
