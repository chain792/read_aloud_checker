class Api::V1::User::SentencesController < ApplicationController
  def index
    sentences = current_user.sentences.order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end

  def create
    sentence = current_user.sentences.build(sentence_params)
    if sentence.save
      head :no_content
    else
      render json: sentence.errors.full_messages, status: :bad_request
    end
  end

  def edit
    sentence = current_user.sentences.find(params[:id])
    render json: SentenceResource.new(sentence).serialize
  end

  def update
    sentence = current_user.sentences.find(params[:id])
    if sentence.update(sentence_params)
      head :no_content
    else
      render json: sentence.errors.full_messages, status: :bad_request
    end
  end

  def destroy
    sentence = current_user.sentences.find(params[:id])
    sentence.destroy!
    head :no_content
  end

  private

  def sentence_params
    params.require(:sentence).permit(:title, :body, :status, :thumbnail)
  end
end
