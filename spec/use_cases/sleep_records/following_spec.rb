# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepRecords::Following do
  let(:user) { User.create!(name: 'Test User') }
  let(:followed_user) { User.create!(name: 'Followed User') }
  let(:other_user) { User.create!(name: 'Other User') }

  before do
    Follow.create!(follower: user, followed: followed_user)
    # Sleep records for followed user (within 7 days)
    @recent_record = SleepRecord.create!(user: followed_user, start_time: 2.days.ago, end_time: 1.day.ago)
    # Sleep records for followed user (older than 7 days)
    @old_record = SleepRecord.create!(user: followed_user, start_time: 10.days.ago, end_time: 9.days.ago)
    # Sleep records for other user
    SleepRecord.create!(user: other_user, start_time: 2.days.ago, end_time: 1.day.ago)
  end

  it 'returns sleep records of followed users within 7 days' do
    result = described_class.new(user_id: user.id).call
    expect(result).to be_success
    expect(result.value![:data]).to include(@recent_record)
    expect(result.value![:data]).not_to include(@old_record)
    expect(result.value![:meta][:total_data]).to eq(1)
  end

  it 'returns failure if no records found' do
    result = described_class.new(user_id: other_user.id).call
    expect(result).to be_failure
    expect(result.failure[:message]).to eq('No following sleep records found.')
    expect(result.failure[:status]).to eq(:not_found)
  end

  it 'paginates results' do
    # Create more records for pagination
    25.times do |i|
      SleepRecord.create!(user: followed_user, start_time: 3.days.ago, end_time: 2.days.ago, created_at: i.hours.ago)
    end
    result = described_class.new(user_id: user.id, page: 2, per_page: 20).call
    expect(result).to be_success
    expect(result.value![:data].size).to eq(6) # 26 records total, 20 on first page, 6 on second
    expect(result.value![:meta][:page]).to eq(2)
    expect(result.value![:meta][:per_page]).to eq(20)
    expect(result.value![:meta][:total_data]).to eq(26)
  end
end
