class Sentence < ApplicationRecord
  include UuidPk

  belongs_to :creater, polymorphic: true

  enum status: { public_state: 0, private_state: 1 }

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 10000 }
  validates :status, presence: true

end
