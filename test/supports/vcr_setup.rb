require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/supports/fixtures/vcr_cassettes"
  config.ignore_localhost = true
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data("<STRIPE_SECRET_KEY>"){ Rails.application.credentials.dig(:stripe, :secret_key) }
  # other VCR configurations...
end