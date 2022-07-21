class ApplicationController < ActionController::API
  include Api::UserAuthenticator
  before_action :authenticate!
end
