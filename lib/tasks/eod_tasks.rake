# lib/tasks/eod_tasks.rake

require 'logger'

logger = Logger.new(STDOUT)

namespace :eod do
  desc "Perform end of day calculations"
  task calculate: :environment do
    begin
      logger.info "Starting EOD calculations"

      subjects = ResultData.distinct.pluck(:subject)
      subjects.each do |subject|
        results = ResultData.where('DATE(timestamp) = ? AND subject = ?', Date.today, subject)
        daily_stats = results.pluck(:marks)

        logger.info "Daily stats for subject #{subject}: #{daily_stats}"
        daily_low = daily_stats.min
        daily_high = daily_stats.max
        result_count = daily_stats.count

        if daily_stats.any?
          DailyResultStat.create!(
            date: Date.today,
            subject: subject,
            daily_low: daily_low,
            daily_high: daily_high,
            result_count: result_count
          )
          logger.info "Daily result stats created for subject: #{subject}"
        else
          logger.info "No results for subject: #{subject}"
        end
      end

      if Date.today == DateHelper.monday_of_third_wednesday_week(Date.today)
        calculate_monthly_averages(logger)
      end

      logger.info "EOD calculations completed successfully"
    rescue StandardError => e
      logger.fatal "EOD calculation failed: #{e.message}"
    end
  end

  def calculate_monthly_averages(logger)
    begin
      subjects = DailyResultStat.select(:subject).distinct
      subjects.each do |subject|
        total_results = 0
        daily_stats = []
        start_date = Date.today - 5.days
        end_date = Date.today - 1.day  # Exclude today's records
        max_days_back = 30  # Limit the number of days to go back

        while total_results < 200 && max_days_back > 0 do
          stats = DailyResultStat.where('date >= ? AND date <= ? AND subject = ?', start_date, end_date, subject.subject)
          total_results += stats.sum(:result_count)
          daily_stats += stats
          end_date = start_date - 1.day
          start_date -= 5.days
          max_days_back -= 5
        end

        logger.info "Collected daily stats for subject #{subject.subject}: #{daily_stats.map(&:attributes)}"
        if daily_stats.any?
          monthly_avg_low = daily_stats.sum(&:daily_low) / daily_stats.size
          monthly_avg_high = daily_stats.sum(&:daily_high) / daily_stats.size

          MonthlyAverage.create!(
            date: Date.today,
            subject: subject.subject,
            monthly_avg_low: monthly_avg_low,
            monthly_avg_high: monthly_avg_high,
            monthly_result_count_used: total_results
          )
          logger.info "Monthly averages created for subject: #{subject.subject}"
        else
          logger.info "No daily stats for subject: #{subject.subject}"
        end
      end
    rescue StandardError => e
      logger.fatal "Monthly average calculation failed: #{e.message}"
    end
  end
end
