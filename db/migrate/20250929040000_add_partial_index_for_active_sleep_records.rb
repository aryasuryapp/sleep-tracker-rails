# frozen_string_literal: true

# Migration to add a partial index for active sleep records (where end_time is NULL)
class AddPartialIndexForActiveSleepRecords < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL.squish
      CREATE INDEX idx_active_sleep_records
      ON sleep_records(user_id)
      WHERE end_time IS NULL
    SQL
  end

  def down
    execute <<-SQL.squish
      DROP INDEX IF EXISTS idx_active_sleep_records
    SQL
  end
end
