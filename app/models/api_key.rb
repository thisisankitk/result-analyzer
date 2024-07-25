# app/models/api_key.rb

class ApiKey < ApplicationRecord
  before_create :generate_access_token

  def generate_access_token
    self.access_token = SecureRandom.hex
  end

  def self.ransackable_attributes(auth_object = nil)
    ["access_token", "created_at", "updated_at"]
  end
end
