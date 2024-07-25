ActiveAdmin.register ResultData do
  permit_params :subject, :timestamp, :marks

  index do
    selectable_column
    id_column
    column :subject
    column :timestamp
    column :marks
    actions
  end

  filter :subject
  filter :timestamp
  filter :marks

  form do |f|
    f.inputs do
      f.input :subject
      f.input :timestamp, as: :datetime_picker
      f.input :marks
    end
    f.actions
  end

  action_item :download_csv, only: :index do
    link_to 'Download CSV', admin_result_data_path(format: 'csv')
  end

  collection_action :download_csv do
    results = ResultData.all
    csv = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Subject', 'Timestamp', 'Marks']
      results.each do |result|
        csv << [result.id, result.subject, result.timestamp, result.marks]
      end
    end
    send_data csv, filename: "results-#{Date.today}.csv"
  end
end
