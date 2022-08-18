class Api::V1::User::TrainingsController < ApplicationController
  def index
    trainings = current_user.trainings.order(created_at: :desc)
    render json: TrainingResource.new(trainings).serialize
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
    params.require(:training).permit(:word_count, :sentence_id, result_words_attributes: [:word])
  end
end
