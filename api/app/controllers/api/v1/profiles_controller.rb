class Api::V1::ProfilesController < ApplicationController
  include Api::AwsS3

  def presigned_post
    render json: presigned_post_of_public_bucket("user/avatar/#{current_user.id}/#{params[:name]}")
  end

  def update
    user = User.find(current_user.id)
    if user.update(user_params)
      render json: UserResource.new(user).serialize
    else
      render json: user.errors.full_messages, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
end
