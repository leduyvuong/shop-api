# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Addresses API', type: :request do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET /api/v1/addresses' do
    it 'returns current user addresses' do
      create_list(:address, 2, user:)

      get '/api/v1/addresses'

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['success']).to be(true)
      expect(json['data'].size).to eq(2)
    end
  end

  describe 'POST /api/v1/addresses' do
    it 'creates a new address' do
      params = {
        address: {
          name: 'Home',
          phone: '0987654321',
          province: 'HCM',
          district: 'District 3',
          ward: 'Ward 5',
          street: '123 Street',
          default: true
        }
      }

      post '/api/v1/addresses', params: params

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['success']).to be(true)
      expect(json['data']['default']).to be(true)
      expect(user.addresses.default.count).to eq(1)
    end
  end

  describe 'PATCH /api/v1/addresses/:id/set_default' do
    it 'marks the address as default and unsets previous ones' do
      first_address = create(:address, user:, default: true)
      second_address = create(:address, user:, default: false)

      patch "/api/v1/addresses/#{second_address.id}/set_default"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['success']).to be(true)
      expect(json['data']['id']).to eq(second_address.id)
      expect(second_address.reload.default).to be(true)
      expect(first_address.reload.default).to be(false)
    end
  end
end
