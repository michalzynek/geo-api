# frozen_string_literal: true

# == Schema Information
#
# Table name: geolocations
#
#  id         :bigint           not null, primary key
#  ip         :string
#  country    :string
#  city       :string
#  latitude   :decimal(, )
#  longitude  :decimal(, )
#  provider   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  host       :string
#
# Indexes
#
#  index_geolocations_on_ip_and_host  (ip,host) UNIQUE
#
describe API::V1::GeolocationsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/geolocations/').to route_to('api/v1/geolocations#index', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/geolocations/').to route_to('api/v1/geolocations#create', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/geolocations/1').to route_to('api/v1/geolocations#show', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/geolocations/1').to route_to('api/v1/geolocations#destroy', id: '1', format: :json)
    end
  end
end
