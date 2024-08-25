# frozen_string_literal: true

module Helpers
  # Helper method to parse a response
  #
  # @return [Hash]
  def json
    JSON.parse(response.body).with_indifferent_access
  end

  # Helper method to generate and include request token
  #
  # @return [String]
  def auth_headers
    api_key = APIKey.create!

    { 'Authorization' => api_key.raw_token }
  end
end
