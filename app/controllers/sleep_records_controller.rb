# frozen_string_literal: true

# app/controllers/sleep_records_controller.rb
class SleepRecordsController < ApplicationController
  before_action :set_user

  # GET /sleep_records
  # List all current user's sleep records (sorted by created_at)
  def index
    records = current_user.sleep_records.order(created_at: :asc)
    render json: records
  end

  # POST /sleep_records/clock_in
  def clock_in
    result = SleepRecords::ClockIn.new(user: current_user).call
    if result.success?
      render json: { message: result.success[:message], data: result.success[:data] }, status: :created
    else
      error = result.failure
      render json: { error: error[:message] }, status: error[:status]
    end
  end

  # POST /sleep_records/clock_out
  def clock_out
    result = SleepRecords::ClockOut.new(user: current_user).call
    if result.success?
      render json: { message: result.success[:message], data: result.success[:data] }, status: :ok
    else
      error = result.failure
      render json: { error: error[:message] }, status: error[:status]
    end
  end
end
