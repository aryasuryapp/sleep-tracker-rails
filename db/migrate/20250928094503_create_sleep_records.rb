class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.datetime :start_time, null: false, index: true
      t.datetime :end_time, null: false, index: true

      t.timestamps
    end
  end
end
