# frozen_string_literal: true

module Middleware
  class RequestLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      Rails.logger.info("Request: #{request.request_method} #{request.url} params=#{request.params}")
      status, headers, response = @app.call(env)
      Rails.logger.info("Response: status=#{status} headers=#{headers.slice('Content-Type', 'Content-Length')}")
      [status, headers, response]
    end
  end
end
