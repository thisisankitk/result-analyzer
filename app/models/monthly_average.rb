# app/models/monthly_average.rb

class MonthlyAverage < ApplicationRecord
  validates :date, presence: true
  validates :subject, presence: true
  validates :monthly_avg_low, presence: true, numericality: true
  validates :monthly_avg_high, presence: true, numericality: true
  validates :monthly_result_count_used, presence: true, numericality: { only_integer: true }

  def self.ransackable_attributes(auth_object = nil)
    ["date", "subject", "monthly_avg_low", "monthly_avg_high", "monthly_result_count_used", "created_at", "updated_at"]
  end
end
