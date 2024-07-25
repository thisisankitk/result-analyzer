ActiveAdmin.register DailyResultStat do
  permit_params :date, :subject, :daily_low, :daily_high, :result_count

  index do
    selectable_column
    id_column
    column :date
    column :subject
    column :daily_low
    column :daily_high
    column :result_count
    actions
  end

  filter :date
  filter :subject
  filter :daily_low
  filter :daily_high
  filter :result_count

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :subject
      f.input :daily_low
      f.input :daily_high
      f.input :result_count
    end
    f.actions
  end
end
