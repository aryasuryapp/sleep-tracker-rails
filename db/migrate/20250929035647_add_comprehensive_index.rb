# frozen_string_literal: true

# Migration to add comprehensive indexes to optimize queries for retrieving sleep records of followed users
class AddComprehensiveIndex < ActiveRecord::Migration[7.1]
  def change
    # Time based index for created_at to optimize queries filtering by creation time
    add_index :sleep_records, :created_at

    # Composite index for follower_id and created_at to optimize joins and filtering by creation time
    add_index :sleep_records, %i[user_id created_at], name: 'index_sleep_records_on_user_id_and_created_at'

    add_index :sleep_records, %i[user_id created_at duration], name: 'idx_sleep_records_user_time_duration'
    add_index :sleep_records, %i[duration user_id created_at], name: 'idx_sleep_records_duration_user_time'
  end
end
