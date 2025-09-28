# frozen_string_literal: true

# Change end_time to allow null values in sleep_records
class ChangeEndTimeNullOnSleepRecords < ActiveRecord::Migration[7.1]
  def change
    change_column_null :sleep_records, :end_time, true
  end
end
