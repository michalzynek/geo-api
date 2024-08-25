# frozen_string_literal: true

namespace :token do
  desc 'Generates API token to use for API requests'
  task generate: :environment do
    puts 'Generating API Token...'
    api_key = APIKey.create!
    token = api_key.raw_token

    puts "API TOKEN: #{token}\nCOPY AND STORE IT SAFELY!"
  end
end
