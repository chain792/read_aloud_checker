class Api::V1::Admin::SentencesController < AdminController
  def index
    q = Sentence.ransack(params[:q])
    sentences = q.result(distinct: true).order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(sentences)
    render json: pagenation.merge(JSON.parse SentenceResource.new(sentences).serialize)
  end

  def update
    sentence = Sentence.find(params[:id])
    if sentence.update(sentence_params)
      render json: SentenceResource.new(sentence).serialize
    else
      render json: sentence.errors.full_messages, status: :bad_request
    end
  end

  def destroy
    sentence = Sentence.find(params[:id])
    sentence.destroy!
    head :no_content
  end

  private

  def sentence_params
    params.require(:sentence).permit(:title, :body, :status)
  end
end
