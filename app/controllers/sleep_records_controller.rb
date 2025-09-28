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
    # Ensure user doesn't already have an open record (end_time is nil)
    if current_user.sleep_records.exists?(end_time: nil)
      return render json: { error: 'Already clocked in, must clock out first.' }, status: :unprocessable_content
    end

    record = current_user.sleep_records.create!(start_time: Time.current)
    render json: record, status: :created
  end

  # POST /sleep_records/clock_out
  def clock_out
    record = current_user.sleep_records.where(end_time: nil).order(created_at: :desc).first

    return render json: { error: 'No active sleep session found.' }, status: :unprocessable_content unless record

    record.update!(end_time: Time.current)
    render json: record
  end

  def following
    result = SleepRecords::Following.new(user_id: params[:id]).call
    if result.success?
      render json: { message: result.success[:message], data: result.success[:data] }, status: :ok
    else
      error = result.failure
      render json: { error: error[:message] }, status: error[:status]
    end
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
