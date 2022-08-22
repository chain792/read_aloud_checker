class Api::V1::SentencesController < ApplicationController
  skip_before_action :authenticate!, only: %i[show]

  def show
    sentence = Sentence.find(params[:id])
    render json: SentenceWithBookmarksResource.new(sentence).serialize
  end

  def bookmark
    sentences = current_user.bookmark_sentences.order('bookmarks.updated_at desc')
    render json: SentenceResource.new(sentences).serialize
  end
end
