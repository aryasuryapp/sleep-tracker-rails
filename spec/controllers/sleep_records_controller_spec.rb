# frozen_string_literal: true

# spec/controllers/sleep_records_controller_spec.rb
require 'rails_helper'

def json_response
  response.parsed_body
end

RSpec.describe SleepRecordsController, type: :controller do
  let(:user) { User.create!(name: 'Test User') }
  let!(:record1) { user.sleep_records.create!(start_time: 2.days.ago, end_time: 1.day.ago) }
  let!(:record2) { user.sleep_records.create!(start_time: 1.day.ago, end_time: Time.current) }

  before do
    allow(User).to receive(:find).and_return(user)
    # Simulate authentication
    allow_any_instance_of(SleepRecordsController).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns all sleep records for the user sorted by created_at' do
      get :index, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2)
      expect(json_response.first['id']).to eq(record1.id)
      expect(json_response.last['id']).to eq(record2.id)
    end
  end

  describe 'POST #clock_in' do
    it 'creates a new sleep record if none is open' do
      user.sleep_records.where(end_time: nil).delete_all
      expect do
        post :clock_in, params: { id: user.id }
      end.to change { user.sleep_records.count }.by(1)
      expect(response).to have_http_status(:created)
      expect(json_response['end_time']).to be_nil
    end

    it 'returns error if already clocked in' do
      user.sleep_records.create!(start_time: Time.current, end_time: nil)
      post :clock_in, params: { id: user.id }
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response['error']).to eq('Already clocked in, must clock out first.')
    end
  end

  describe 'POST #clock_out' do
    it 'closes the open sleep record' do
      open_record = user.sleep_records.create!(start_time: Time.current, end_time: nil)
      post :clock_out, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(open_record.id)
      expect(json_response['end_time']).not_to be_nil
    end

    it 'returns error if no active sleep session' do
      user.sleep_records.where(end_time: nil).delete_all
      post :clock_out, params: { id: user.id }
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response['error']).to eq('No active sleep session found.')
    end
  end

  describe 'GET #following' do
    let(:other_user) { User.create!(name: 'Other User') }
    let(:follow) { Follow.create!(follower: user, followed: other_user) }
    let!(:other_record) { other_user.sleep_records.create!(start_time: 3.days.ago, end_time: 2.days.ago) }

    before do
      follow
    end

    it 'returns sleep records of followed users' do
      get :following, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'].first['id']).to eq(other_record.id)
    end

    it 'returns not found if no following sleep records' do
      follow.destroy
      get :following, params: { id: user.id }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('No following sleep records found.')
    end
  end
end
