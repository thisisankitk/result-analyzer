# app/models/admin_user.rb

class AdminUser < ApplicationRecord
  # Add devise modules if required
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    ["email", "created_at", "updated_at"]
  end
end
