class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate!, only: %i[index create]
  def index
    logger.info '----------start------------'
    logger.info request.headers['Authorization']
    logger.info request.base_url
    logger.info cookies[:refresh_token]
    logger.info '----------start------------'
    render json: 'index'
  end

  def create
    user = User.new(user_params)
    # 入力フォームのパスワード入力は1回にしているためpasswordの値を代入する
    user.password_confirmation = user.password
    if user.save
      refresh_token = user.refresh_me!
      set_refresh_token_to_cookie(refresh_token)
      access_token = user.create_access_token.transform_keys{|k| k.to_s.camelize(:lower)}
      render json: access_token.merge(user: UserResource.new(user).serialize)
    else
      render json: user.errors.full_messages, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
