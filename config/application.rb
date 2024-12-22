require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventBuster
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version
    config.load_defaults 7.1
    config.assets.enabled = true


    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))


    #adding secure headers
    config.action_dispatch.default_headers.merge!(
  'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains', # enforce HTTPS
  'X-Content-Type-Options' => 'nosniff', # prevent MIME type sniffing
  'X-Frame-Options' => 'DENY', # prevent clickjacking
  'Content-Security-Policy' => "default-src 'self'; script-src 'self'; style-src 'self'", # CSP
  'Referrer-Policy' => 'strict-origin-when-cross-origin' # pestrict referrer leakage
)


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
