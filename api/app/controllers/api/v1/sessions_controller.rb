class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate!

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      refresh_token = user.refresh_me!
      set_refresh_token_to_cookie(refresh_token)
      access_token = user.create_access_token
      render json: { token: access_token }
    else
      head :unauthorized
    end
  end
end
