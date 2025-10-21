# frozen_string_literal: true

class ServiceResult
  attr_reader :payload, :errors

  def initialize(success:, payload: {}, errors: [])
    @success = success
    @payload = payload
    @errors = Array(errors)
  end

  def success?
    @success
  end

  def failure?
    !success?
  end

  def order
    payload[:order]
  end

  def payment
    payload[:payment]
  end
end
