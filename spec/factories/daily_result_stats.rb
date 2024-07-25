FactoryBot.define do
  factory :daily_result_stat do
    date { Date.today }
    subject { "Science" }
    daily_low { rand(50..100) }
    daily_high { rand(50..100) }
    result_count { rand(1..100) }
  end
end
