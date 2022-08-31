class Api::V1::User::SentencesController < ApplicationController
  def index
    sentences = current_user.sentences.order(created_at: :desc)
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
