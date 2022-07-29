class News < ApplicationRecord
  belongs_to :news_category
  has_one :sentence, as: :creater, dependent: :destroy
end
