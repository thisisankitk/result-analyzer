require 'rails_helper'
require 'rake'
require 'timecop'

# Helper method for common assertions
def expect_monthly_avg(avg, date, subject, low, high, count)
  expect(avg).not_to be_nil
  expect(avg.date).to eq(date)
  expect(avg.subject).to eq(subject)
  expect(avg.monthly_avg_low.to_f).to be_within(0.01).of(low)
  expect(avg.monthly_avg_high.to_f).to be_within(0.01).of(high)
  expect(avg.monthly_result_count_used).to eq(count)
end

RSpec.shared_context 'EOD calculations setup' do
  before :all do
    Rake.application.rake_require 'tasks/eod_tasks'
    Rake::Task.define_task(:environment)
  end

  let!(:api_key) { create(:api_key) }

  before do
    allow(DateHelper).to receive(:monday_of_third_wednesday_week).and_return(Date.today)
    # Set up the testing month
    wednesday = DateHelper.recent_month_starting_with_wednesday
    monday = DateHelper.monday_of_third_wednesday_week(wednesday)
    Timecop.travel(monday)
  end

  after do
    Timecop.return
  end
end

RSpec.describe 'eod:calculate', type: :task do
  include_context 'EOD calculations setup'

  describe 'Daily calculations' do
    before do
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
  end

  describe 'Monthly calculations' do
    before do
      create(:daily_result_stat, date: Date.today, subject: 'Science', daily_low: 50.75, daily_high: 99.50, result_count: 35)
      create(:daily_result_stat, date: Date.today - 3.days, subject: 'Science', daily_low: 51, daily_high: 99, result_count: 53)
      create(:daily_result_stat, date: Date.today - 4.days, subject: 'Science', daily_low: 52, daily_high: 98, result_count: 55)
      create(:daily_result_stat, date: Date.today - 5.days, subject: 'Science', daily_low: 53, daily_high: 97, result_count: 27)
    end

    it 'calculates monthly averages on the correct day' do
      # Ensure daily_result_stat records have appropriate dates and values
      create(:daily_result_stat, date: Date.today - 6.days, subject: 'Science', daily_low: 54, daily_high: 96, result_count: 45)
      Rake::Task['eod:calculate'].reenable
      Rake::Task['eod:calculate'].invoke
      monthly_avg = MonthlyAverage.find_by(date: Date.today, subject: 'Science')

      expect_monthly_avg(monthly_avg, Date.today, 'Science', 52.15, 97.90, 215)
    end

    it 'calculates monthly averages by going back in days for minimum data requirement' do
      create(:daily_result_stat, date: Date.today - 7.days, subject: 'Science', daily_low: 56.50, daily_high: 90.00, result_count: 15)
      create(:daily_result_stat, date: Date.today - 6.days, subject: 'Science', daily_low: 80.00, daily_high: 77.50, result_count: 30)

      Rake::Task['eod:calculate'].reenable
      Rake::Task['eod:calculate'].invoke
      monthly_avg = MonthlyAverage.find_by(date: Date.today, subject: 'Science')

      expect_monthly_avg(monthly_avg, Date.today, 'Science', 57.35, 94.20, 200)
    end

    it 'calculates monthly averages by going back in days up to max days (30)' do
      create(:daily_result_stat, date: Date.today - 32.days, subject: 'Science', daily_low: 70.00, daily_high: 95.00, result_count: 20)
      create(:daily_result_stat, date: Date.today - 31.days, subject: 'Science', daily_low: 60.00, daily_high: 85.00, result_count: 10)
      create(:daily_result_stat, date: Date.today - 30.days, subject: 'Science', daily_low: 65.00, daily_high: 88.00, result_count: 5)
      create(:daily_result_stat, date: Date.today - 29.days, subject: 'Science', daily_low: 78.00, daily_high: 90.50, result_count: 5)
      create(:daily_result_stat, date: Date.today - 6.days, subject: 'Science', daily_low: 80.00, daily_high: 77.50, result_count: 5)

      Rake::Task['eod:calculate'].reenable
      Rake::Task['eod:calculate'].invoke
      monthly_avg = MonthlyAverage.find_by(date: Date.today, subject: 'Science')

      expect_monthly_avg(monthly_avg, Date.today, 'Science', 61.39, 92.79, 185)
    end
  end
end
