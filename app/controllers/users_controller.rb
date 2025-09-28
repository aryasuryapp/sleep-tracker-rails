# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
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
end
