class CustomLogger < Rails::Rack::Logger
  def call(env)
    if env["REQUEST_PATH"] == "/api/v1/health_check"
      Rails.logger.silence do
        super
      end
    else
      super
    end
  end
end
App::Application.config.middleware.swap Rails::Rack::Logger, CustomLogger
