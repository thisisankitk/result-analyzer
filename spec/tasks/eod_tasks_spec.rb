require 'rails_helper'
require 'rake'

RSpec.describe 'eod:calculate', type: :task do
  before :all do
    Rake.application.rake_require 'tasks/eod_tasks'
    Rake::Task.define_task(:environment)
  end

  describe 'EOD calculations' do
    let!(:api_key) { create(:api_key) }

    before do
      allow(DateHelper).to receive(:monday_of_third_wednesday_week).and_return(Date.today)
      # Creating ResultData records with timestamps matching Date.today
      ResultData.create!(subject: 'Science', timestamp: Date.today.to_datetime + 12.hours, marks: 85.25)
      ResultData.create!(subject: 'Science', timestamp: Date.today.to_datetime + 13.hours, marks: 90.50)
      ResultData.create!(subject: 'Science', timestamp: Date.today.to_datetime + 14.hours, marks: 78.00)
    end

    it 'calculates daily result stats' do
      Rake::Task['eod:calculate'].reenable
      Rake::Task['eod:calculate'].invoke
      stats = DailyResultStat.find_by(date: Date.today, subject: 'Science')

      expect(stats).not_to be_nil
      expect(stats.date).to eq(Date.today)
      expect(stats.subject).to eq('Science')
      expect(stats.daily_low.to_f).to eq(78.00)
      expect(stats.daily_high.to_f).to eq(90.50)
      expect(stats.result_count).to eq(3)
    end

    it 'calculates monthly averages on the correct day' do
      # Ensure daily_result_stat records have appropriate dates and values
      create(:daily_result_stat, date: Date.today - 1.day, subject: 'Science', daily_low: 50, daily_high: 100, result_count: 30)
      create(:daily_result_stat, date: Date.today - 2.days, subject: 'Science', daily_low: 51, daily_high: 99, result_count: 30)
      create(:daily_result_stat, date: Date.today - 3.days, subject: 'Science', daily_low: 52, daily_high: 98, result_count: 30)
      create(:daily_result_stat, date: Date.today - 4.days, subject: 'Science', daily_low: 53, daily_high: 97, result_count: 30)
      create(:daily_result_stat, date: Date.today - 5.days, subject: 'Science', daily_low: 54, daily_high: 96, result_count: 30)
      create(:daily_result_stat, date: Date.today - 6.days, subject: 'Science', daily_low: 55, daily_high: 95, result_count: 30)

      Rake::Task['eod:calculate'].reenable
      Rake::Task['eod:calculate'].invoke
      monthly_avg = MonthlyAverage.find_by(date: Date.today, subject: 'Science')

      expect(monthly_avg).not_to be_nil
      expect(monthly_avg.date).to eq(Date.today)
      expect(monthly_avg.subject).to eq('Science')
      expect(monthly_avg.monthly_avg_low.to_f).to be_within(0.01).of(52.5)  # Adjust expected value if necessary
      expect(monthly_avg.monthly_avg_high.to_f).to be_within(0.01).of(97.5)  # Adjust expected value if necessary
      expect(monthly_avg.monthly_result_count_used).to eq(180)  # Adjust if necessary based on the logic
    end
  end
end
