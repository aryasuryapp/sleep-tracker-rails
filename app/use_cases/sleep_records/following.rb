# frozen_string_literal: true

module SleepRecords
  # Use case to get sleep records of users that the given user is following
  class Following
    include Dry::Monads[:result]

    def initialize(user_id:, page: 1, per_page: 20)
      @user_id = user_id
      @page = [page.to_i, 1].max
      @per_page = per_page.to_i < 1 ? 20 : per_page.to_i
    end

    def call
      offset = (@page - 1) * @per_page
      base_query = SleepRecord.joins(user: :followers)
                              .where(follows: { follower_id: @user_id })
                              .where(start_time: 7.days.ago..Time.current)
      total_data = base_query.count
      records = base_query.order(updated_at: :desc)
                          .limit(@per_page)
                          .offset(offset)

      if records.present?
        meta = { total_data: total_data, page: @page, per_page: @per_page }
        Success(message: 'Following sleep records retrieved successfully.', data: records, meta: meta)
      else
        Failure(message: 'No following sleep records found.', status: :not_found)
      end
    end
  end
end
