class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :sentence

  validates :user_id, uniqueness: { scope: :sentence_id }
end
