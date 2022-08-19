class Api::V1::BookmarksController < ApplicationController
  def create
    sentence = Sentence.find(params[:sentence_id])
    current_user.bookmark(sentence)
    head :no_content
  end

  def destroy
    sentence = Sentence.find(params[:sentence_id])
    current_user.unbookmark(sentence)
    head :no_content
  end
end
