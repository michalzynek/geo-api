# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups

RSpec.describe GeolocationCreatorService do
  describe '.call' do
    subject { described_class.new(ip_or_host, provider:).call }

    describe 'IPStack' do
      let(:provider) { GeolocationProvider::IpStack::Provider }

      context 'when IP/Host is valid' do
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
        let(:geolocation) { Geolocation.last }

        before { subject }

        it 'creates new geolocation record' do
          expect(geolocation.ip).to eq(ip_or_host)
          expect(geolocation.host).to eq(ip_or_host)
          expect(geolocation.country).to eq(params[:country_name])
          expect(geolocation.city).to eq(params[:city])
          expect(geolocation.latitude).to eq(params[:latitude])
          expect(geolocation.longitude).to eq(params[:longitude])
          expect(geolocation.provider).to eq(GeolocationProvider::IpStack::Provider::NAME)
        end
      end

      context 'when IP/Host is invalid' do
        include_context 'when ipstack request'
        let(:ip_or_host) { Faker::Internet.ip_v4_address }
        let(:params) do
          {
            ip: ip_or_host,
            country_name: nil,
            city: nil,
            latitude: 0,
            longitude: 0
          }
        end
        let(:ipstack_response) { params.to_json }
        let(:geolocation) { Geolocation.last }

        it 'raises validation error' do
          expect { subject }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end
end

# rubocop:enable RSpec/NestedGroups
