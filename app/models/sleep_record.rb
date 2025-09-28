# frozen_string_literal: true

# app/models/sleep_records.rb
class SleepRecord < ApplicationRecord
  # Validations
  validates :start_time, presence: true

  belongs_to :user
end
