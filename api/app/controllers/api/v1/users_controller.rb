class Api::V1::UsersController < ApplicationController
  def index
    render json: 'Hello User Index'
  end

  def create
    user = User.new(user_params)
    # 入力フォームのパスワード入力は1回にしているためpasswordの値を代入する
    user.password_confirmation = user.password
    if user.save
      render json: UserResource.new(user).serialize
    else
      render json: user.errors.full_messages, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
