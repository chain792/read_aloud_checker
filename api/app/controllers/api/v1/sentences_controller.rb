class Api::V1::SentencesController < ApplicationController
  def show
    sentence = Sentence.find(params[:id])
    render json: SentenceResource.new(sentence).serialize
  end
end
