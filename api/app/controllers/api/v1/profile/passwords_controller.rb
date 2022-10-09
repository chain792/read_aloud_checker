class Api::V1::Profile::PasswordsController < ApplicationController
  def update  user = User.find(current_user.id)

  
    

    
    if user.valid_password?(params[:current_password])
      if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        render json: UserResource.new(user).serialize
      else
        render json: user.errors.full_messages, status: :bad_request
      end
    else
      user.errors.add(:base, '現在のパスワードが違います')
      render json: user.errors.full_messages, status: :bad_request
    end
  end
end
