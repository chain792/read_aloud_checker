class Api::V1::User::TrainingsController < ApplicationController
  def index
    trainings = current_user.trainings.includes(:sentence, :result_words).order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(trainings)
    render json: pagenation.merge(JSON.parse TrainingResource.new(trainings).serialize)
  end

  def create
    training = current_user.trainings.build(training_params)
    if training.save
      render json: TrainingResource.new(training).serialize
    else
      render json: training.errors.full_messages, status: :bad_request
    end
  end

  def show
    training = current_user.trainings.find(params[:id])
    render json: TrainingResource.new(training).serialize
  end

  private

  def training_params
    params.require(:training).permit(
      :sentence_id, :title, :body, :male_speech, :female_speech,
      result_words_attributes: %i[position result]
    )
  end
end
