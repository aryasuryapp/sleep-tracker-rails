# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: %i[show followers following follow unfollow]

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
    result = FollowUser.new(follower: current_user, followed: User.find(params[:target_user_id])).call

    if result.success?
      follow = result.value!
      render json: { message: 'Followed successfully', follow: follow }, status: :created
    else
      error = result.failure
      render json: { error: error[:message] }, status: error[:status]
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Target user not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def unfollow
    result = UnfollowUser.new(follower: current_user, followed: User.find(params[:target_user_id])).call

    if result.success?
      render json: { message: 'Unfollowed successfully' }, status: :ok
    else
      render json: { error: result.failure }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Target user not found.' }, status: :not_found
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
