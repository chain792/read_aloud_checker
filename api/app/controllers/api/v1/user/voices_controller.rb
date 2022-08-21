class Api::V1::User::VoicesController < ApplicationController
  include Api::AwsS3

  def create
    training = current_user.trainings.find(params[:training_id])
    training.voice = params[:voice]
    if training.save
      head :no_content
    else
      render json: training.errors.full_messages, status: :bad_request
    end
  end

  def presigned_post
    render json: presigned_post_of_private_bucket("training/voice/#{current_user.id}/#{SecureRandom.urlsafe_base64}")
  end

  def presign
    render json: presigned_url("training/voice/#{current_user.id}/#{params[:name]}")
  end
end
