class Api::V1::Sentences::CategoriesController < ApplicationController
  skip_before_action :authenticate!

  def index
    sentences = Category.find_by(name: params[:keyword]).sentences.includes(:categories).popular(params[:sort]).order('sentences.created_at desc').page(params[:page])
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end
end
