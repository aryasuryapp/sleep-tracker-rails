# frozen_string_literal: true

module SleepRecords
  # Use case to clock in (start a sleep record) for a user
  class ClockIn
    include Dry::Monads[:result]

    def initialize(user:)
      @user = user
    end

    def call
      # Ensure user doesn't already have an open record (end_time is nil)
      if @user.sleep_records.exists?(end_time: nil)
        return Failure(message: 'Already clocked in, must clock out first.', status: :unprocessable_content)
      end

      @user.sleep_records.create!(start_time: Time.current)
      records = @user.sleep_records.order(created_at: :desc).limit(10)
      Success(message: 'Clock-in successful.', data: records)
    rescue StandardError => e
      Failure(message: e.message, status: :internal_server_error)
    end
  end
end
