class ResultWord < ApplicationRecord
  belongs_to :training

  validates :word, presence: true
end
