# frozen_string_literal: true

RSpec.describe GeolocationProvider::IpStack::Parser do
  describe '.call' do
    subject { described_class.new(response).call }

    let(:response) do
      Faraday::Response.new(
        body: expected_hash.merge(country_name: 'United States').to_json
      )
    end
    let(:expected_hash) do
      {
        ip: Faker::Internet.ip_v4_address,
        country: 'United States',
        city: 'Chicago',
        latitude: 10.0,
        longitude: 11.1
      }
    end

    it 'parses the response properly' do
      expect(subject).to eq(expected_hash)
    end
  end
end
