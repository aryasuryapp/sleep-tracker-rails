# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: %i[show followers following follow]

  # GET /users
  # List all current users
  def index
    records = ListUsers.new.call
    render json: records
  end

  def show
    user = ShowUser.new.call(params[:id])
    render json: user
  end

  def followers
    followers = ListFollowers.new.call(params[:id])
    render json: followers
  end

  def following
    following = ListFollowing.new.call(params[:id])
    render json: following
  end

  def follow
    target_user = User.find(params[:target_user_id])
    FollowUser.new(follower: current_user, followed: target_user).call
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Target user not found.' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    if e.record.errors.full_messages.include?('Follower has already been taken')
      return render json: { error: 'Already following this user.' }, status: :unprocessable_content
    end

    render json: { error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_content
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Current user not found.' }, status: :not_found
  end

  def current_user
    @user # Replace with auth logic (e.g. Devise)
  end
end
