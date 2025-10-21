# frozen_string_literal: true

namespace :swagger do
  desc 'Generate swagger docs'
  task generate: :environment do
    system 'bundle exec rswag:specs:swaggerize'
  end
end
