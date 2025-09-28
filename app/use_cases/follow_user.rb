# frozen_string_literal: true

require 'dry/monads'

# app/use_cases/follow_user.rb
class FollowUser
  include Dry::Monads[:result]

  def initialize(follower:, followed:)
    @follower = follower
    @followed = followed
  end

  def call
    return Failure(message: 'Cannot follow yourself.', status: :unprocessable_content) if @follower == @followed

    Follow.create!(follower: @follower, followed: @followed)
    Success(message: 'Followed successfully!', data: { followed_user: @followed })
  rescue ActiveRecord::RecordInvalid => e
    if e.record.errors.full_messages.include?('Follower has already been taken')
      return Failure(message: 'Already following this user.', status: :unprocessable_content)
    end

    Failure(message: e.record.errors.full_messages.join(', '), status: :unprocessable_content)
  end
end
