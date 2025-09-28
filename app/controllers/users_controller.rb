# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # GET /users
  # List all current users
  def index
    records = User.all
    render json: records
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def followers
    user = User.find(params[:id])
    render json: user.followers
  end

  def following
    user = User.find(params[:id])
    render json: user.following
  end
end
