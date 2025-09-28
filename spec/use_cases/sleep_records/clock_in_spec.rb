# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepRecords::ClockIn, type: :use_case do
  let(:user) { User.create!(name: 'Test User') }

  subject { described_class.new(user: user) }

  context 'when user has no open sleep record' do
    it 'creates a new sleep record and returns success' do
      result = subject.call
      expect(result).to be_success
      expect(result.value![:message]).to eq('Clock-in successful.')
      expect(result.value![:data].first).to be_a(SleepRecord)
      expect(user.sleep_records.last.start_time).to be_within(2.seconds).of(Time.current)
    end
  end

  context 'when user already has an open sleep record' do
    before { user.sleep_records.create!(start_time: 1.hour.ago, end_time: nil) }

    it 'returns failure and does not create a new record' do
      result = subject.call
      expect(result).to be_failure
      expect(result.failure[:message]).to eq('Already clocked in, must clock out first.')
      expect(user.sleep_records.count).to eq(1)
    end
  end

  context 'when an exception occurs' do
    before do
      allow(user.sleep_records).to receive(:exists?).and_raise(StandardError, 'DB error')
    end

    it 'returns failure with error message' do
      result = subject.call
      expect(result).to be_failure
      expect(result.failure[:message]).to eq('DB error')
    end
  end
end
