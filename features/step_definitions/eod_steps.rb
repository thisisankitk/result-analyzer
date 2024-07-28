require_relative '../../app/helpers/date_helper'

def replace_placeholders_with_dates(text)
  text.gsub('TODAY', Date.today.strftime('%Y-%m-%d'))
      .gsub('3_DAYS_AGO', (Date.today - 3).strftime('%Y-%m-%d'))
      .gsub('4_DAYS_AGO', (Date.today - 4).strftime('%Y-%m-%d'))
      .gsub('5_DAYS_AGO', (Date.today - 5).strftime('%Y-%m-%d'))
      .gsub('6_DAYS_AGO', (Date.today - 6).strftime('%Y-%m-%d'))
      .gsub('7_DAYS_AGO', (Date.today - 7).strftime('%Y-%m-%d'))
      .gsub('8_DAYS_AGO', (Date.today - 8).strftime('%Y-%m-%d'))
      .gsub('29_DAYS_AGO', (Date.today - 29).strftime('%Y-%m-%d'))
      .gsub('30_DAYS_AGO', (Date.today - 30).strftime('%Y-%m-%d'))
      .gsub('31_DAYS_AGO', (Date.today - 31).strftime('%Y-%m-%d'))
      .gsub('32_DAYS_AGO', (Date.today - 32).strftime('%Y-%m-%d'))
      .gsub('33_DAYS_AGO', (Date.today - 33).strftime('%Y-%m-%d'))
end

Given('an API key is generated') do
  @api_key = ApiKey.create!
end

Given('we are in the testing month') do
  wednesday = DateHelper.recent_month_starting_with_wednesday
  monday = DateHelper.monday_of_third_wednesday_week(wednesday)
  Timecop.travel(monday)
end

Given('the following test results exist:') do |table|
  table.hashes.each do |row|
    timestamp = replace_placeholders_with_dates(row['timestamp'])
    ResultData.create!(subject: row['subject'], timestamp: timestamp, marks: row['marks'])
  end
end

Given('the following daily result stats exist:') do |table|
  table.hashes.each do |row|
    date = replace_placeholders_with_dates(row['date'])
    DailyResultStat.create!(date: date, subject: row['subject'], daily_low: row['daily_low'], daily_high: row['daily_high'], result_count: row['result_count'])
  end
end

When('the EOD task runs') do
  Rake::Task['eod:calculate'].reenable
  Rake::Task['eod:calculate'].invoke
end

When('the EOD task runs on the Monday of the third Wednesday week') do
  allow(DateHelper).to receive(:monday_of_third_wednesday_week).and_return(Date.today)
  Rake::Task['eod:calculate'].reenable
  Rake::Task['eod:calculate'].invoke
end

Then('the daily result stats should be:') do |table|
  table.hashes.each do |row|
    date = replace_placeholders_with_dates(row['date'])
    stats = DailyResultStat.find_by(date: date, subject: row['subject'])
    expect(stats).not_to be_nil
    expect(stats.daily_low.to_f).to eq(row['daily_low'].to_f)
    expect(stats.daily_high.to_f). to eq(row['daily_high'].to_f)
    expect(stats.result_count).to eq(row['result_count'].to_i)
  end
end

Then('the monthly averages should be:') do |table|
  table.hashes.each do |row|
    date = replace_placeholders_with_dates(row['date'])
    avg = MonthlyAverage.find_by(date: date, subject: row['subject'])
    expect(avg).not_to be_nil
    expect(avg.monthly_avg_low.to_f).to eq(row['monthly_avg_low'].to_f)
    expect(avg.monthly_avg_high.to_f).to eq(row['monthly_avg_high'].to_f)
    expect(avg.monthly_result_count_used).to eq(row['monthly_result_count_used'].to_i)
  end
end

After do
  Timecop.return
end
