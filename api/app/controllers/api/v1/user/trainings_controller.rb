class Api::V1::User::TrainingsController < ApplicationController
  def create
    training = current_user.trainings.build(training_params)
    if training.save
      render json: TrainingResource.new(training).serialize
    else
      render json: training.errors.full_messages, status: :bad_request
    end
  end

  private

  def training_params
    params.require(:training).permit(:word_count, :sentence_id, result_words_attributes: [:word])
  end
end
