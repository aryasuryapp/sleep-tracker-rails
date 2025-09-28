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

  private

  def set_user
    @user = User.find(params[:id])
  end

  # In a real app this comes from authentication
  def current_user
    @user # Replace with auth logic (e.g. Devise)
  end
end
