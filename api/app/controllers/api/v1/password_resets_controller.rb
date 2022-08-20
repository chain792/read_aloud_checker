class Api::V1::PasswordResetsController < ApplicationController
  skip_before_action :authenticate!

  def create
    user = User.find_by_email(params[:email])
    user.deliver_reset_password_instructions! if user
    head :no_content
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      head :unauthorized
    else
      head :ok
    end
  end

  def update
    token = params[:id]
    user = User.load_from_reset_password_token(params[:id])

    if user.blank?
      head :unauthorized
      return
    end

    user.password_confirmation = params[:user][:password_confirmation]
    # the next line clears the temporary token and updates the password
    if user.change_password(params[:user][:password])
      head :ok
    else
      render json: user.errors.full_messages, status: :bad_request
    end
  end
end
