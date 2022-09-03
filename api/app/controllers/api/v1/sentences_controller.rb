class Api::V1::SentencesController < ApplicationController
  include Api::Kaminari
  skip_before_action :authenticate!, only: %i[show]

  def show
    sentence = Sentence.find(params[:id])
    render json: DetailSentenceResource.new(sentence).serialize
  end

  def bookmark
    sentences = current_user.bookmark_sentences.order('bookmarks.updated_at desc').page(params[:page])
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end
end
