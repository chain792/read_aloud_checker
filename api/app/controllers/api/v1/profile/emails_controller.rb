class Api::V1::Profile::EmailsController < ApplicationController
  def update
    user = User.find(current_user.id)

    if user.valid_password?(params[:password])
      if user.update(email: params[:email])
        render json: UserResource.new(user).serialize
      else
        render json: user.errors.full_messages, status: :bad_request
      end
    else
      user.errors.add(:password, 'が違います')
      render json: user.errors.full_messages, status: :bad_request
    end
  end
end
