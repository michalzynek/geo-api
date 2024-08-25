# frozen_string_literal: true

# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint           not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_api_keys_on_token  (token) UNIQUE
#
require 'rails_helper'

RSpec.describe APIKey do
  describe '.find_token!' do
    subject { described_class.find_token!(api_token) }

    let(:api_token) { create(:api_key).raw_token }

    it 'finds record by given raw token' do
      expect(subject).to be_present
    end

    it 'does not expose raw token once created' do
      expect(subject.raw_token).to be_nil
    end
  end

  describe '.generate_digest' do
    let(:token) { 'dummy' }
    let(:hmac_secret_key) { 'test' }
    let(:encrypted_token) { OpenSSL::HMAC.hexdigest('SHA256', hmac_secret_key, token) }

    before { stub_const('APIKey::HMAC_SECRET_KEY', hmac_secret_key) }

    it 'encrypts securely the token' do
      expect(described_class.generate_digest(token)).to eq(
        OpenSSL::HMAC.hexdigest('SHA256', hmac_secret_key, token)
      )
    end
  end
end
