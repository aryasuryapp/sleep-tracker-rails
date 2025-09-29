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
      following_users = User.joins(:followers).where(follows: { follower_id: @user_id }).select(:id)
      base_query = SleepRecord.includes(:user)
                              .where(user_id: following_users)
                              .where(created_at: 7.days.ago..Time.current)
      total_data = base_query.count
      records = base_query.order(duration: :desc)
                          .limit(@per_page)
                          .offset(offset)

      result_data = records.map do |record|
        {
          id: record.id,
          start_time: record.start_time,
          end_time: record.end_time,
          duration: record.duration,
          duration_hours: record.duration_hours,
          created_at: record.created_at,
          updated_at: record.updated_at,
          user: {
            id: record.user.id,
            name: record.user.name
          }
        }
      end

      if records.present?
        meta = { total_data: total_data, page: @page, per_page: @per_page }
        Success(message: 'Following sleep records retrieved successfully.', data: result_data, meta: meta)
      else
        Failure(message: 'No following sleep records found.', status: :not_found)
      end
    end
  end
end
