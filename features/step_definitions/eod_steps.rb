# features/step_definitions/eod_steps.rb

Given('an API key is generated') do
  @api_key = ApiKey.create!
end

Given('the following test results exist:') do |table|
  table.hashes.each do |row|
    ResultData.create!(subject: row['subject'], timestamp: row['timestamp'], marks: row['marks'])
  end
end

Given('the following daily result stats exist:') do |table|
  table.hashes.each do |row|
    DailyResultStat.create!(date: row['date'], subject: row['subject'], daily_low: row['daily_low'], daily_high: row['daily_high'], result_count: row['result_count'])
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
    stats = DailyResultStat.find_by(date: row['date'], subject: row['subject'])
    expect(stats).not_to be_nil
    expect(stats.daily_low.to_f).to eq(row['daily_low'].to_f)
    expect(stats.daily_high.to_f).to eq(row['daily_high'].to_f)
    expect(stats.result_count).to eq(row['result_count'].to_i)
  end
end

Then('the monthly averages should be:') do |table|
  table.hashes.each do |row|
    avg = MonthlyAverage.find_by(date: row['date'], subject: row['subject'])
    expect(avg).not_to be_nil
    expect(avg.monthly_avg_low.to_f).to be_within(0.01).of(row['monthly_avg_low'].to_f)
    expect(avg.monthly_avg_high.to_f).to be_within(0.01).of(row['monthly_avg_high'].to_f)
    expect(avg.monthly_result_count_used).to eq(row['monthly_result_count_used'].to_i)
  end
end
