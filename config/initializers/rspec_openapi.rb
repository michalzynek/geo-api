# frozen_string_literal: true

return unless Rails.env.test?

require 'rspec/openapi'

# Support generating the docs when running specs with `parallel_tests`
RSpec::OpenAPI.path = ->(_) { "doc/openapi#{ENV.fetch('TEST_ENV_NUMBER', '')}.yaml" }

RSpec::OpenAPI.title = 'Geolocation API'

RSpec::OpenAPI.application_version = '1.2.1'

RSpec::OpenAPI.security_schemes = {
  'Authorization' => {
    description: 'Authenticate API requests via API Token',
    in: 'header',
    name: 'Authorization',
    type: 'apiKey'
  }
}
