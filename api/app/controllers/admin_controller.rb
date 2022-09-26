class AdminController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    head :unauthorized unless current_user.admin?
  end
end
