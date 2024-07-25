# app/models/result_data.rb

class ResultData < ApplicationRecord
  validates :subject, presence: true
  validates :timestamp, presence: true
  validates :marks, presence: true, numericality: true

  def self.ransackable_attributes(auth_object = nil)
    ["subject", "timestamp", "marks", "created_at", "updated_at"]
  end
end
