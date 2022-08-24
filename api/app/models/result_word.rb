class ResultWord < ApplicationRecord
  belongs_to :training

  validates :position, presence: true

  enum result: { succeeded: 0, failed: 1, symbol: 2, ignored: 3, ruby_waved: 4 }
end
