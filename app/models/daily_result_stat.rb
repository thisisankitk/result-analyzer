# app/models/daily_result_stat.rb

class DailyResultStat < ApplicationRecord
  validates :date, presence: true
  validates :subject, presence: true
  validates :daily_low, presence: true, numericality: true
  validates :daily_high, presence: true, numericality: true
  validates :result_count, presence: true, numericality: { only_integer: true }

  def self.ransackable_attributes(auth_object = nil)
    ["date", "subject", "daily_low", "daily_high", "result_count", "created_at", "updated_at"]
  end
end
