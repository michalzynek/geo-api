# frozen_string_literal: true

RSpec.describe GeolocationProvider::IpStack::Provider do
  describe '.call' do
    subject { described_class.new(ip_or_host).call }

    context 'when service returns successful response' do
      include_context 'when ipstack request'
      let(:ip_or_host) { Faker::Internet.ip_v4_address }
      let(:params) do
        {
          ip: ip_or_host,
          country_name: 'United States',
          city: 'Chicago',
          latitude: 10.0,
          longitude: 11.1
        }
      end
      let(:ipstack_response) { params.to_json }

      it 'returns geolocation params' do
        expect(subject[:ip]).to eq(ip_or_host)
        expect(subject[:host]).to eq(ip_or_host)
        expect(subject[:country]).to eq(params[:country_name])
        expect(subject[:city]).to eq(params[:city])
        expect(subject[:latitude]).to eq(params[:latitude])
        expect(subject[:longitude]).to eq(params[:longitude])
        expect(subject[:provider]).to eq(GeolocationProvider::IpStack::Provider::NAME)
      end
    end

    context 'when service is unavailable' do
      include_context 'when ipstack service error request'
      let(:ip_or_host) { Faker::Internet.ip_v4_address }

      it 'raises ServiceConnectionError' do
        expect { subject }.to raise_error GeolocationProvider::BaseProvider::ServiceConnectionError
      end
    end
  end
end
