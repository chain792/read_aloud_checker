class Api::V1::Admin::UsersController < AdminController
  def index
    users = User.order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(users)
    render json: pagenation.merge(JSON.parse UserResource.new(users).serialize)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
