class Api::V1::User::ListeningSexesController < ApplicationController
  def update
    user = User.find(current_user.id)
    user.update!(user_params)
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:listening_sex)
  end
end