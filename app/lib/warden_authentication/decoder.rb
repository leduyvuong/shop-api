# frozen_string_literal: true

module WardenAuthentication
  class Decoder
    def self.call(request)
      new(request).decode
    end

    def initialize(request)
      @request = request
    end

    def decode
      return unless jwt_token

      Warden::JWTAuth::UserDecoder.new.call(jwt_token, :user, nil)
    rescue StandardError
      nil
    end

    private

    attr_reader :request

    def jwt_token
      pattern = /^Bearer /i
      header = request.headers['Authorization']
      header.gsub(pattern, '') if header&.match(pattern)
    end
  end
end
