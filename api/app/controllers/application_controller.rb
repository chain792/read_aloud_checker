class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Api::UserAuthenticator
  before_action :xhr_request?
  before_action :authenticate!

  private

  def xhr_request?
    return if request.xhr?
    head :forbidden
  end
end
