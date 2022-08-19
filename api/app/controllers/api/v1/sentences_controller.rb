class Api::V1::SentencesController < ApplicationController
  def show
    sentence = Sentence.find(params[:id])
    render json: SentenceResource.new(sentence).serialize
  end

  def bookmark
    sentences = current_user.bookmark_sentences.order('bookmarks.updated_at desc')
    render json: SentenceResource.new(sentences).serialize
  end
end
