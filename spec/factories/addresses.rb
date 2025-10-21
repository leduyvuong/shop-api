# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    association :user
    name { Faker::Name.name }
    phone { '0123456789' }
    province { 'HCM' }
    district { 'District 1' }
    ward { 'Ward 1' }
    street { Faker::Address.street_address }
    default { false }
  end
end
