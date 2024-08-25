# frozen_string_literal: true

module GeolocationProvider
  module IpStack
    class Parser
      def initialize(response)
        @response = response
      end

      def call
        parse_response
      end

      private

      def parse_response
        response_body = JSON.parse(@response.body)

        {
          ip: response_body['ip'],
          country: response_body['country_name'],
          city: response_body['city'],
          latitude: response_body['latitude'],
          longitude: response_body['longitude']
        }
      end
    end
  end
end
