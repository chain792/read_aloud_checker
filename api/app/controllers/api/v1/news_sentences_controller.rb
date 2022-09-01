class Api::V1::NewsSentencesController < ApplicationController
  include Api::Kaminari
  skip_before_action :authenticate!

  def index
    sentences = Sentence.public_state.where(creater_type: 'News').order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end
end
