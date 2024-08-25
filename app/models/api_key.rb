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
class APIKey < ApplicationRecord
  HMAC_SECRET_KEY = ENV.fetch('HMAC_SECRET_KEY', Rails.application.credentials.api_key_hmac_secret_key)

  before_create :generate_raw_token
  before_create :generate_token

  attr_accessor :raw_token

  def self.find_token!(token)
    find_by!(token: generate_digest(token))
  end

  def self.generate_digest(token)
    OpenSSL::HMAC.hexdigest('SHA256', HMAC_SECRET_KEY, token)
  end

  private

  def generate_raw_token
    self.raw_token = SecureRandom.base58(30)
  end

  def generate_token
    self.token = self.class.generate_digest(raw_token)
  end
end
