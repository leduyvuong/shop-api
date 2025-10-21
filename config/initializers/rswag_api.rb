# frozen_string_literal: true

Rswag::Api.configure do |c|
  c.swagger_root = Rails.root.join('swagger').to_s
end

Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api/v1/docs/v1/swagger.yaml', 'API V1 Docs'
end
