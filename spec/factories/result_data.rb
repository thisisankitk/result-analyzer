FactoryBot.define do
  factory :result_data do
    subject { "Science" }
    timestamp { Time.now }
    marks { rand(50..100) }
  end
end
