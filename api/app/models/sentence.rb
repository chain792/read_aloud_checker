class Sentence < ApplicationRecord
  include UuidPk
  belongs_to :creater, polymorphic: true
end
