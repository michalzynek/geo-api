# frozen_string_literal: true

module GeolocationProvider
  module IpStack
    class Provider < BaseProvider
      NAME = 'IPSTACK'
      API_BASE_URL = 'http://api.ipstack.com'

      def call
        fetch_data
      end

      private

      def api_client
        Faraday.new(
          url: API_BASE_URL,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      def access_key
        ENV.fetch('IPSTACK_ACCESS_KEY', nil)
      end

      def fetch_data
        response = api_client.get("/#{@ip_or_host}?access_key=#{access_key}")

        unless response.success?
          raise ServiceConnectionError,
                "Invalid response (#{response.status}) from IPStack: #{response.inspect}"
        end

        Parser.new(response).call.merge(
          provider: NAME,
          host: @ip_or_host
        )
      end
    end
  end
end
