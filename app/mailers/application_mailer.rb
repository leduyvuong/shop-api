# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@shop-api.test'
  layout 'mailer'
end
