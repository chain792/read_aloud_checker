class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Api::UserAuthenticator
  before_action :authenticate!
end
