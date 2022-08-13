class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate!

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      refresh_token = user.refresh_me!
      set_refresh_token_to_cookie(refresh_token)
      access_token = user.create_access_token.transform_keys{|k| k.to_s.camelize(:lower)}
      render json: access_token.merge(user: UserResource.new(user).serialize)
    else
      head :unauthorized
    end
  end

  def refresh
    refresh_token = cookies[:refresh_token]
    user = User.load_from_refresh_token(refresh_token)

    if user
      access_token = user.create_access_token.transform_keys{|k| k.to_s.camelize(:lower)}
      render json: access_token.merge(user: UserResource.new(user).serialize)
    else
      head :unauthorized
    end
  end

  def destroy
    cookies.delete(:refresh_token, secure: true)
  end
end
