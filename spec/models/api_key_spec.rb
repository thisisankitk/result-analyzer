require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it 'generates a unique access token on creation' do
    api_key = ApiKey.create!
    expect(api_key.access_token).to be_present
  end

  it 'ensures access token is unique' do
    api_key1 = ApiKey.create!
    api_key2 = ApiKey.create!
    expect(api_key1.access_token).not_to eq(api_key2.access_token)
  end
end
