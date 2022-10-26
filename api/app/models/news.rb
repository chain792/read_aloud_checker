class News < ApplicationRecord
  has_one :sentence, as: :creater, dependent: :destroy

  validates :title, presence: true
end
