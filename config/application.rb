# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module ShopApi
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = true

    config.middleware.use Rack::Attack
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 expose: %w[Authorization],
                 methods: %i[get post put patch delete options head]
      end
    end

    config.middleware.insert_after Rack::Runtime, Middleware::RequestLogger

    config.active_storage.service = :local
    config.active_job.queue_adapter = :async

    %w[app/services app/policies app/lib middleware].each do |path|
      config.autoload_paths << Rails.root.join(path)
      config.eager_load_paths << Rails.root.join(path)
    end
  end
end
