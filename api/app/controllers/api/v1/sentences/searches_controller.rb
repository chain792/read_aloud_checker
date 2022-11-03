class Api::V1::Sentences::SearchesController < ApplicationController
  def index
    q = Sentence.ransack(params[:q])
    sentences = q.result(distinct: true).includes(:categories).popular(params[:sort]).order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end
end
