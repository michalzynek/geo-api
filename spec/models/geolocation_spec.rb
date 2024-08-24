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
require 'rails_helper'

RSpec.describe Geolocation do
  describe 'IP address/Host validations' do
    context 'when IP is present and supported' do
      subject { build(:geolocation, :ipstack) }

      it 'passes validation' do
        expect(subject).to be_valid
      end
    end

    context 'when IP is not supported' do
      subject { build(:geolocation, :ipstack, ip: 'DUMMY') }

      it 'is not a valid record' do
        expect(subject).not_to be_valid
      end
    end

    context 'when IP and host are missing' do
      subject { build(:geolocation, :ipstack, ip: nil, host: nil) }

      it 'is not a valid record' do
        expect(subject).not_to be_valid
      end
    end

    context 'when IP or host is present' do
      subject { build(:geolocation, :ipstack, host: nil) }

      it 'passes validation' do
        expect(subject).to be_valid
      end
    end

    describe 'IP and host uniqueness' do
      subject { build(:geolocation, :ipstack, ip: '10.0.0.1', host: 'https://google.com') }

      before { create(:geolocation, :ipstack, ip: '10.0.0.1', host: 'https://google.com') }

      it 'when pair of IP and host is not unique is not a valid record' do
        expect(subject.save).to be_falsey
      end
    end
  end
end
