class Sentence < ApplicationRecord
  mount_uploader :thumbnail, ThumbnailUploader

  require 'nkf'
  include UuidPk

  belongs_to :creater, polymorphic: true
  has_many :trainings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :sentence_categories, dependent: :destroy
  has_many :categories, through: :sentence_categories, source: :category

  enum status: { public_state: 0, private_state: 1 }

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 10000 }
  validates :status, presence: true

  # 全角を半角にする
  before_save -> { self.body = NKF.nkf('-w -Z1 -Z4 -x', body) }
  before_save -> { self.word_count = body.split.length }
  after_create :create_speech
  after_update :create_speech, if: :saved_change_to_body?

  scope :user_published, -> { public_state.where(creater_type: 'User') }
  scope :news_published, -> { public_state.where(creater_type: 'News') }
  scope :popular, ->(sort) { left_joins(:trainings).group(:id).order('count(sentences.id) desc') if sort == 'popular' }

  def create_speech
    self.female_speech = AwsPollyService.call(body, 'Joanna', "sentence/speech/#{id}")
    self.male_speech = AwsPollyService.call(body, 'Matthew', "sentence/speech/#{id}")
    save
  end

  def save_with_categories(name)
    ActiveRecord::Base.transaction do
      save!
      self.categories = name.blank? ? [] : [Category.find_or_initialize_by(name: name.strip)]
    end
    true
  rescue StandardError
    false
  end
end
