ActiveAdmin.register MonthlyAverage do
  permit_params :date, :subject, :monthly_avg_low, :monthly_avg_high, :monthly_result_count_used

  index do
    selectable_column
    id_column
    column :date
    column :subject
    column :monthly_avg_low
    column :monthly_avg_high
    column :monthly_result_count_used
    actions
  end

  filter :date
  filter :subject
  filter :monthly_avg_low
  filter :monthly_avg_high
  filter :monthly_result_count_used

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :subject
      f.input :monthly_avg_low
      f.input :monthly_avg_high
      f.input :monthly_result_count_used
    end
    f.actions
  end
end
