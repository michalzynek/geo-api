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
FactoryBot.define do
  factory :geolocation do
    ip { Faker::Internet.ip_v4_address }
    country { Faker::Address.country }
    city { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    host { Faker::Internet.url }

    trait :ipstack do
      provider { 'IPSTACK' }
    end
  end
end
