class Api::V1::HealthChecksController < ActionController::API
  def index
    head :ok
  end
end
