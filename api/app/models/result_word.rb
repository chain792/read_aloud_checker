class ResultWord < ApplicationRecord
  include UuidPk

  belongs_to :training
end
