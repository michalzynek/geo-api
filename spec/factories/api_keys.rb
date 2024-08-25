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
FactoryBot.define do
  factory :api_key do
    trait :explicit do
      token { SecureRandom.base58(30) }
    end
  end
end
