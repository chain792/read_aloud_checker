class Api::V1::SentencesController < ApplicationController
  before_action :sentence_params, only: %i[create]

  def index
    sentences = Sentence.public_state.where(creater_type: 'User').order(created_at: :desc)
    render json: SentenceResource.new(sentences).serialize
  end

  def create
    sentence = current_user.sentences.build(sentence_params)
    if sentence.save
      render json: SentenceResource.new(sentence).serialize
    else
      render json: sentence.errors.full_messages, status: :bad_request
    end
  end

  private

  def sentence_params
    params.require(:sentence).permit(:title, :body, :status)
  end
end
