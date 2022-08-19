class Api::V1::NewsSentencesController < ApplicationController
  skip_before_action :authenticate!

  def index
    sentences = Sentence.public_state.where(creater_type: 'News').order(created_at: :desc)
    render json: SentenceResource.new(sentences).serialize
  end
end
