# frozen_string_literal: true

class Rack::Attack
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip
  end

  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    req.params['email'].presence if req.path == '/api/v1/auth/sign_in' && req.post?
  end
end
