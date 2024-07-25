FactoryBot.define do
  factory :monthly_average do
    date { Date.today }
    subject { "Science" }
    monthly_avg_low { rand(50..100) }
    monthly_avg_high { rand(50..100) }
    monthly_result_count_used { rand(200..300) }
  end
end
