class Api::V1::SentencesController < ApplicationController
  skip_before_action :authenticate!, only: %i[index show]

  def index
    case params[:type]
    when 'user'
      sentences = Sentence.user_published.order(created_at: :desc).page(params[:page])
    when 'news'
      sentences = Sentence.news_published.includes(creater: :news_category).order(created_at: :desc).page(params[:page])
    end
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end

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
