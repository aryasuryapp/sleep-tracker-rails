# frozen_string_literal: true

module SleepRecords
  # Use case to clock out (end a sleep record) for a user
  class ClockOut
    include Dry::Monads[:result]

    def initialize(user:)
      @user = user
    end

    def call
      clock_out_time = Time.current
      # Find the most recent open sleep record (end_time is nil)
      record = @user.sleep_records.where(end_time: nil).order(created_at: :desc).first

      return Failure(message: 'No active sleep session found.', status: :unprocessable_content) unless record

      duration = clock_out_time - record.start_time
      record.update!(end_time: clock_out_time, duration: duration, duration_hours: duration / 3600.0)
      Success(message: 'Clock-out successful.', data: record)
    rescue StandardError => e
      Failure(message: e.message, status: :internal_server_error)
    end
  end
end
