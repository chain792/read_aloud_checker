class Sentence < ApplicationRecord
  include UuidPk
  belongs_to :creater, polymorphic: true

  enum status: { public_state: 0, private_state: 1 }
end
