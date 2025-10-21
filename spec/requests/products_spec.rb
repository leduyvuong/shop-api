# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  describe 'GET /api/v1/products' do
    it 'returns success response' do
      create_list(:product, 3)
      get '/api/v1/products'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['success']).to eq(true)
    end
  end
end
