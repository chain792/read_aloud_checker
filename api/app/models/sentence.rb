class Sentence < ApplicationRecord
  require 'nkf'
  include UuidPk

  belongs_to :creater, polymorphic: true
  has_many :trainings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  enum status: { public_state: 0, private_state: 1 }

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 10000 }
  validates :status, presence: true

  # 全角を半角にする
  before_save -> { self.body = NKF.nkf('-w -Z1 -Z4 -x', self.body) }
  after_create :create_speech
  after_update :create_speech, if: :saved_change_to_body?

  def create_speech
    self.female_speech = AwsPollyService.call(body, 'Joanna', "sentence/speech/#{id}")
    self.male_speech = AwsPollyService.call(body, 'Matthew', "sentence/speech/#{id}")
    save
  end
end
