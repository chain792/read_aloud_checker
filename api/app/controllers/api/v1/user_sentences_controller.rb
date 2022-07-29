class Api::V1::UserSentencesController < ApplicationController
  def index
    sentences = Sentence.public_state.where(creater_type: 'User').order(created_at: :desc)
    render json: SentenceResource.new(sentences).serialize
  end
end
