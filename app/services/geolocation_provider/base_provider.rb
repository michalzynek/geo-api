# frozen_string_literal: true

module GeolocationProvider
  class BaseProvider
    class ServiceConnectionError < StandardError; end

    def initialize(ip_or_host)
      @ip_or_host = ip_or_host
    end

    def call
      raise NotImplementedError
    end
  end
end
