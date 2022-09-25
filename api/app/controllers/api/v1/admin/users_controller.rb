class Api::V1::Admin::UsersController < AdminController
  def index
    q = User.ransack(params[:q])
    users = q.result(distinct: true).order(created_at: :desc).page(params[:page])
    pagenation = resources_with_pagination(users)
    render json: pagenation.merge(JSON.parse UserResource.new(users).serialize)
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: UserResource.new(user).serialize
    else
      render json: user.errors.full_messages, status: :bad_request
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
