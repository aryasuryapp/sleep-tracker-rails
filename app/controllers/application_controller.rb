# frozen_string_literal: true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  def set_user
    @user = User.find(params[:current_user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Current user not found.' }, status: :not_found
  end

  # In a real app this comes from authentication
  def current_user
    @user # Replace with auth logic (e.g. Devise)
  end
end
