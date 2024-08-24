# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Geolocations' do
  describe 'GET api/v1/geolocations' do
    let(:request) { get api_v1_geolocations_path, params: }

    before do
      create_list(:geolocation, 10, :ipstack, ip: Faker::Internet.ip_v4_address)
      request
    end

    context 'when search params are present' do
      let(:geolocation) { Geolocation.first }
      let(:params) { { query: geolocation.ip } }

      it 'returns successfully list of resources' do
        expect(response).to have_http_status(:success)
        expect(json[:data][0][:attributes][:ip]).to eq(geolocation.ip)
      end
    end

    context 'when no search param is given' do
      let(:params) { nil }

      it 'returns 400 bad request' do
        expect(response).to have_http_status(:bad_request)
        expect(json[:errors]).to include('Query parameter is required (should be IP or Host)')
      end
    end

    describe 'paginated response' do
      let(:params) { { query: Geolocation.first.ip } }

      it 'returns paginated results with links' do
        expect(response).to have_http_status(:success)
        expect(json[:links][:next]).to be_present
      end
    end
  end

  describe 'GET api/v1/geolocations/:id' do
    before { request }

    context 'when geolocation record does not exist' do
      let(:request) { get api_v1_geolocation_path('dummy') }

      it 'returns 404 not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when geolocation record exists' do
      let(:geolocation) { create(:geolocation, :ipstack) }
      let(:request) { get api_v1_geolocation_path(geolocation.id) }
      let(:response_body) { json[:data] }

      it 'returns successfully single resource' do
        expect(response).to have_http_status(:success)
        expect(json[:data][:id]).to eq(geolocation.id.to_s)
        expect(json[:data][:attributes][:ip]).to eq(geolocation.ip)
      end
    end
  end

  describe 'DELETE api/v1/geolocations/:id' do
    before { request }

    context 'when geolocation record does not exist' do
      let(:request) { delete api_v1_geolocation_path('dummy') }

      it 'returns 404 not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when geolocation record exists' do
      let(:geolocation) { create(:geolocation, :ipstack) }
      let(:request) { delete api_v1_geolocation_path(geolocation.id) }

      it 'returns no content and destroys geolocation' do
        expect(response).to have_http_status(:no_content)
        expect(Geolocation.find_by(id: geolocation.id)).to be_nil
      end
    end
  end

  describe 'POST api/v1/geolocations' do
    before { request }

    let(:request) { post api_v1_geolocations_path, params: }
    let(:params) do
      {
        geolocation: {
          ip:,
          country: Faker::Address.country,
          city: Faker::Address.city,
          latitude: Faker::Address.latitude,
          longitude: Faker::Address.longitude
        }
      }
    end

    context 'when valid payload' do
      let(:ip) { Faker::Internet.ip_v4_address }
      let(:response_body) { json[:data][:attributes] }
      let(:geolocation) { Geolocation.last }

      it 'returns success and creates new geolocation' do
        expect(response).to have_http_status(:created)

        expect(response_body[:ip]).to eq(params[:geolocation][:ip])
        expect(response_body[:host]).to eq(params[:geolocation][:host])
        expect(response_body[:city]).to eq(params[:geolocation][:city])
        expect(response_body[:country]).to eq(params[:geolocation][:country])
        expect(response_body[:latitude]).to eq(params[:geolocation][:latitude].to_s)
        expect(response_body[:longitude]).to eq(params[:geolocation][:longitude].to_s)

        expect(geolocation.ip).to eq(params[:geolocation][:ip])
        expect(geolocation.host).to eq(params[:geolocation][:host])
        expect(geolocation.city).to eq(params[:geolocation][:city])
        expect(geolocation.country).to eq(params[:geolocation][:country])
        expect(geolocation.latitude.to_f).to eq(params[:geolocation][:latitude])
        expect(geolocation.longitude.to_f).to eq(params[:geolocation][:longitude])
      end
    end

    context 'when invalid payload' do
      let(:ip) { 'dummyIP' }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
