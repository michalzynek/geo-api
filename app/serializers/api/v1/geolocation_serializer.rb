# frozen_string_literal: true

module API
  module V1
    class GeolocationSerializer
      include JSONAPI::Serializer

      attributes :ip, :host, :country, :city, :latitude, :longitude, :provider
    end
  end
end
