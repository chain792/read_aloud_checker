class Api::V1::Admin::UsersController < AdminController
  def index
    users = User.order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(users)
    render json: pagenation.merge(JSON.parse UserResource.new(users).serialize)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
