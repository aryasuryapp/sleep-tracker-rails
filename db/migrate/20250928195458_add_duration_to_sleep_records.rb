# frozen_string_literal: true

# This migration adds duration and duration_hours columns to the sleep_records table,
# populates them based on existing start_time and end_time values, and adds indexes for performance
class AddDurationToSleepRecords < ActiveRecord::Migration[7.1]
  def change
    change_table :sleep_records, bulk: true do |t|
      t.integer :duration, null: false, default: 0
      t.integer :duration_hours, null: false, default: 0
    end

    SleepRecord.find_each do |record|
      if record.start_time && record.end_time
        record.update(
          duration: ((record.end_time - record.start_time)).to_i,
          duration_hours: ((record.end_time - record.start_time) / 1.hour).to_i
        )
      end
    end

    add_index :sleep_records, :duration
    add_index :sleep_records, :duration_hours
  end
end
