class CreateResultData < ActiveRecord::Migration[7.1]
  def change
    create_table :result_data do |t|
      t.string :subject
      t.datetime :timestamp
      t.decimal :marks

      t.timestamps
    end
  end
end
