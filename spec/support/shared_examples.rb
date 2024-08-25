# frozen_string_literal: true

shared_context 'when ipstack request context' do
  let(:ipstack_access_key) { ENV.fetch('IPSTACK_ACCESS_KEY', nil) }
  let(:ipstack_endpoint) do
    "#{GeolocationProvider::IpStack::Provider::API_BASE_URL}/#{ip_or_host}?access_key=#{ipstack_access_key}"
  end
end

shared_context 'when ipstack request' do
  include_context 'when ipstack request context'
  before { stub_request(:get, ipstack_endpoint).to_return(body: ipstack_response) }
end

shared_context 'when ipstack service error request' do
  include_context 'when ipstack request context'
  before { stub_request(:get, ipstack_endpoint).to_return(status: [500, 'Internal Server Error']) }
end
