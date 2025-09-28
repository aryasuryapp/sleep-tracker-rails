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

  describe 'GET #following_sleep_records' do
    let(:other_user) { User.create!(name: 'Other User') }
    let(:follow) { Follow.create!(follower: user1, followed: other_user) }
    let!(:other_record) { other_user.sleep_records.create!(start_time: 3.days.ago, end_time: 2.days.ago) }

    before do
      follow
    end

    it 'returns sleep records of followed users' do
      get :following_sleep_records, params: { id: user1.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'].first['id']).to eq(other_record.id)
    end

    it 'returns not found if no following sleep records' do
      follow.destroy
      get :following_sleep_records, params: { id: user1.id }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('No following sleep records found.')
    end
  end

  describe 'POST #follow' do
    it 'allows the current user to follow another user' do
      post :follow, params: { id: user1.id, target_user_id: user3.id }
      expect(json_response['error']).to be_nil
      expect(response).to have_http_status(:created)
      expect(json_response['message']).to eq('Followed successfully!')
      expect(json_response['data']['followed_user']['id']).to eq(user3.id)
      expect(json_response['data']['followed_user']['name']).to eq(user3.name)

      get :following, params: { id: user1.id }
      expect(json_response.size).to eq(2)
      expect(json_response.map { |u| u['id'] }).to include(user2.id, user3.id)
    end

    it 'returns error if trying to follow oneself' do
      post :follow, params: { id: user1.id, target_user_id: user1.id }
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response['error']).to eq('Cannot follow yourself.')
    end

    it 'returns error if target user does not exist' do
      post :follow, params: { id: user1.id, target_user_id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Target user not found.')
    end

    it 'returns error if already following the user' do
      post :follow, params: { id: user1.id, target_user_id: user2.id }
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response['error']).to eq('Already following this user.')
    end

    it 'returns error if current user not found' do
      allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      post :follow, params: { id: 999, target_user_id: user2.id }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Current user not found.')
    end
  end

  describe 'DELETE #unfollow' do
    it 'allows the current user to unfollow another user' do
      delete :unfollow, params: { id: user1.id, target_user_id: user2.id }
      expect(json_response['error']).to be_nil
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Unfollowed successfully!')
      expect(json_response['data']['unfollowed_user']['id']).to eq(user2.id)
      expect(json_response['data']['unfollowed_user']['name']).to eq(user2.name)

      get :following, params: { id: user1.id }
      expect(json_response).to be_empty
    end

    it 'returns error if target user does not exist' do
      delete :unfollow, params: { id: user1.id, target_user_id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Target user not found.')
    end

    it 'returns error if current user not found' do
      allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      delete :unfollow, params: { id: 999, target_user_id: user2.id }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Current user not found.')
    end
  end
end
