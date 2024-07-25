FactoryBot.define do
  factory :api_key do
    access_token { SecureRandom.hex }
  end
end
