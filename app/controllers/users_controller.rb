# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # GET /users
  # List all current users
  def index
    records = User.all
    render json: records
  end
end
