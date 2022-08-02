class ResultWord < ApplicationRecord
  include UuidPk

  belongs_to :training

  validates :word, presence: true
end
