# frozen_string_literal: true

module SleepRecords
  # Use case to get sleep records of users that the given user is following
  class Following
    include Dry::Monads[:result]

    def initialize(user_id:)
      @user_id = user_id
    end

    def call
      result = SleepRecord.joins(user: :followers)
                          .where(follows: { follower_id: @user_id })
                          .order(updated_at: :desc)

      if result.present?
        Success(message: 'Following sleep records retrieved successfully.', data: result)
      else
        Failure(message: 'No following sleep records found.', status: :not_found)
      end
    end
  end
end
