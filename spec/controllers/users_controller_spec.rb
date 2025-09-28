# frozen_string_literal: true

# spec/controllers/users_controller_spec.rb
require 'rails_helper'

def json_response
  response.parsed_body
end

RSpec.describe UsersController, type: :controller do
  let!(:user1) { User.create!(name: 'User 1', id: 1) }
  let!(:user2) { User.create!(name: 'User 2', id: 2) }
  let!(:user3) { User.create!(name: 'User 3', id: 3) }

  # Update the test setup to use the Follow model explicitly
  before do
    Follow.create!(follower: user1, followed: user2)
    Follow.create!(follower: user2, followed: user3)
  end

  describe 'GET #index' do
    it 'returns all users' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns the specified user' do
      get :show, params: { id: user1.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(user1.id)
    end
  end

  describe 'GET #followers' do
    it 'returns the followers of the specified user' do
      get :followers, params: { id: user2.id }
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first['id']).to eq(user1.id)
    end

    it 'returns empty array if user has no followers' do
      get :followers, params: { id: user1.id }
      expect(response).to have_http_status(:ok)
      expect(json_response).to eq([])
    end
  end

  describe 'GET #following' do
    it 'returns the users followed by the specified user' do
      get :following, params: { id: user1.id }
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first['id']).to eq(user2.id)
    end

    it 'returns empty array if user is not following anyone' do
      get :following, params: { id: user3.id }
      expect(response).to have_http_status(:ok)
      expect(json_response).to eq([])
    end
  end
end
