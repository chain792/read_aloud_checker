class Api::V1::Admin::SessionsController < ApplicationController
  skip_before_action :authenticate!

  def create
    user = User.authenticate(params[:email], params[:password])

    if user&.admin?
      refresh_token = user.refresh_me!
      set_refresh_token_to_cookie(refresh_token)
      access_token = user.create_access_token.transform_keys { |k| k.to_s.camelize(:lower) }
      render json: access_token.merge(JSON.parse UserResource.new(user).serialize)
    else
      head :unauthorized
    end
  end
end
