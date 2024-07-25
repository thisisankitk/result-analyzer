module DateHelper
  def self.third_wednesday(date)
    first_day_of_month = date.beginning_of_month
    wednesdays = (first_day_of_month..first_day_of_month.end_of_month).select { |d| d.wednesday? }
    wednesdays[2] # zero-indexed, so the third Wednesday is at index 2
  end

  def self.monday_of_third_wednesday_week(date)
    third_wed = third_wednesday(date)
    third_wed.beginning_of_week(:monday)
  end
end
