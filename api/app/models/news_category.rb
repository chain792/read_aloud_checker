class NewsCategory < ApplicationRecord
  has_many :news, dependent: :destroy

  validates :name, presence: true
end
