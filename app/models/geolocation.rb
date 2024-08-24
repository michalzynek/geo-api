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
class Geolocation < ApplicationRecord
  validates :ip, format: { with: Resolv::IPv4::Regex, message: :must_be_valid_format }
  validates :host, format: { with: URI::DEFAULT_PARSER.make_regexp, allow_blank: true, message: :must_be_valid_format }
  validates :country, :city, :latitude, :longitude, presence: true
  validates :ip, uniqueness: { scope: :host }
  validate :ip_or_host_presence

  private

  def ip_or_host_presence
    errors.add(:base, :ip_or_host_must_be_present) if ip.blank? && host.blank?
  end
end
