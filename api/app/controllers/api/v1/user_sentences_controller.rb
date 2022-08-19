class Api::V1::UserSentencesController < ApplicationController
  skip_before_action :authenticate!

  def index
    sentences = Sentence.public_state.where(creater_type: 'User').order(created_at: :desc)
    render json: SentenceResource.new(sentences).serialize
  end
end
