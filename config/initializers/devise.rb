# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = 'no-reply@shop-api.test'
  require 'devise/orm/active_record'

  config.jwt do |jwt|
    jwt.secret = ENV.fetch('DEVISE_JWT_SECRET_KEY', 'secret-key')
    jwt.dispatch_requests = [
      ['POST', %r{^/api/v1/auth/sign_in$}],
      ['POST', %r{^/api/v1/auth/sign_up$}]
    ]
    jwt.revocation_requests = [['DELETE', %r{^/api/v1/auth/sign_out$}]]
    jwt.expiration_time = 1.day.to_i
  end

  config.navigational_formats = []
end
