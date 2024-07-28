module DateHelper
  def self.third_wednesday(date)
    first_day_of_month = date.beginning_of_month
    wednesdays = (first_day_of_month..first_day_of_month.end_of_month).select { |d| d.wednesday? }
    wednesdays[2]
  end

  def self.monday_of_third_wednesday_week(date)
    third_wed = third_wednesday(date)
    third_wed.beginning_of_week(:monday)
  end

  def self.recent_month_starting_with_wednesday
    current_date = Date.today

    loop do
      first_day_of_month = current_date.beginning_of_month
      return first_day_of_month if first_day_of_month.wednesday?

      current_date = current_date.prev_month
    end
  end
end
