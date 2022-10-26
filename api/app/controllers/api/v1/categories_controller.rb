class Api::V1::CategoriesController < ApplicationController
  skip_before_action :authenticate!, only: %i[index]

  def index
    categories = Category.where('name like ?', "#{params[:word]}%").order(:name).limit(4).pluck(:name)
    render json: categories
  end
end
