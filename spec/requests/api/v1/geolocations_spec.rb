# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Geolocations' do
  describe 'GET api/v1/geolocations' do
    subject { get api_v1_geolocations_path, params: }

    before do
      create_list(:geolocation, 10, :ipstack, ip: Faker::Internet.ip_v4_address)
      subject
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
        expect(json[:errors][0][:message]).to include('Query parameter is required (should be IP or Host)')
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
    before { subject }

    context 'when geolocation record does not exist' do
      subject { get api_v1_geolocation_path('dummy') }

      it 'returns 404 not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when geolocation record exists' do
      subject { get api_v1_geolocation_path(geolocation.id) }

      let(:geolocation) { create(:geolocation, :ipstack) }
      let(:response_body) { json[:data] }

      it 'returns successfully single resource' do
        expect(response).to have_http_status(:success)
        expect(json[:data][:id]).to eq(geolocation.id.to_s)
        expect(json[:data][:attributes][:ip]).to eq(geolocation.ip)
      end
    end
  end

  describe 'DELETE api/v1/geolocations/:id' do
    before { subject }

    context 'when geolocation record does not exist' do
      subject { delete api_v1_geolocation_path('dummy') }

      it 'returns 404 not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when geolocation record exists' do
      subject { delete api_v1_geolocation_path(geolocation.id) }

      let(:geolocation) { create(:geolocation, :ipstack) }

      it 'returns no content and destroys geolocation' do
        expect(response).to have_http_status(:no_content)
        expect(Geolocation.find_by(id: geolocation.id)).to be_nil
      end
    end
  end

  describe 'POST api/v1/geolocations' do
    subject { post api_v1_geolocations_path, params: }

    include_context 'when ipstack request'

    context 'when valid payload with IP' do
      let(:params) { { geolocation: { ip: ip_or_host } } }
      let(:ip_or_host) { Faker::Internet.ip_v4_address }
      let(:response_body) { json[:data][:attributes] }
      let(:geolocation) { Geolocation.last }
      let(:ipstack_response) do
        {
          ip: ip_or_host,
          country_name: 'United States',
          city: 'Chicago',
          latitude: 10.0,
          longitude: 11.1
        }.to_json
      end

      before { subject }

      it 'returns success and creates new geolocation' do
        expect(response).to have_http_status(:created)

        expect(response_body[:ip]).to eq(params[:geolocation][:ip])
        expect(response_body[:host]).to eq(params[:geolocation][:ip])

        expect(geolocation.ip).to eq(params[:geolocation][:ip])
        expect(geolocation.host).to eq(params[:geolocation][:ip])
      end
    end

    context 'when valid payload with host' do
      let(:ip_or_host) { 'google.com' }
      let(:params) { { geolocation: { host: ip_or_host } } }
      let(:ip) { Faker::Internet.ip_v4_address }
      let(:geolocation) { Geolocation.last }
      let(:ipstack_response) do
        {
          ip:,
          country_name: 'United States',
          city: 'Chicago',
          latitude: 10.0,
          longitude: 11.1
        }.to_json
      end

      before { subject }

      it 'returns success and creates new geolocation' do
        expect(response).to have_http_status(:created)

        expect(json[:data][:attributes][:host]).to eq(params[:geolocation][:host])
        expect(json[:data][:attributes][:ip]).to eq(ip)
        expect(geolocation.host).to eq(params[:geolocation][:host])
        expect(geolocation.ip).to eq(ip)
      end
    end

    context 'when invalid payload' do
      let(:ip_or_host) { 'dummyIP' }
      let(:params) { { geolocation: { host: ip_or_host } } }
      let(:ipstack_response) do
        {
          ip: ip_or_host,
          country_name: nil,
          city: nil,
          latitude: nil,
          longitude: nil
        }.to_json
      end

      before { subject }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
