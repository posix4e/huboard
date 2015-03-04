require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HuboardWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.railties_order = [Saas::Engine, :all]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('lib')

    # Configure dalli to use a connection pool
    config.cache_store = :dalli_store, nil, { :pool_size => 5 }

    if ENV["SELF_HOST_FAYE"]
      config.middleware.delete Rack::Lock
      config.middleware.use Faye::RackAdapter, 
        mount: '/site/pubsub', 
        timeout: 25,
        ping: 20,
        engine: {
          type: Faye::Redis,
          uri: (ENV['REDIS_URL'] || 'redis://localhost:6379')
        }
    end
  end
end
