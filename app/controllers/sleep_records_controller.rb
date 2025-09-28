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
    record = current_user.sleep_records.where(end_time: nil).order(created_at: :desc).first

    return render json: { error: 'No active sleep session found.' }, status: :unprocessable_content unless record

    record.update!(end_time: Time.current)
    render json: record
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # In a real app this comes from authentication
  def current_user
    @user # Replace with auth logic (e.g. Devise)
  end
end
