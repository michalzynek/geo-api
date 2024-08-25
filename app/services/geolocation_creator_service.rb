# frozen_string_literal: true

class GeolocationCreatorService
  def initialize(ip_or_host, provider: GeolocationProvider::IpStack::Provider)
    @ip_or_host = ip_or_host
    @provider = provider
  end

  def call
    create_geolocation
  end

  private

  def create_geolocation
    geolocation_data = @provider.new(@ip_or_host).call
    Geolocation.create!(geolocation_data)
  end
end
