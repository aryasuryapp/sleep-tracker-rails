# frozen_string_literal: true

# app/use_cases/follow_user.rb
class FollowUser
  def initialize(follower:, followed:)
    @follower = follower
    @followed = followed
  end

  def call
    raise ArgumentError, 'Cannot follow yourself.' if @follower == @followed

    Follow.create!(follower: @follower, followed: @followed)
  end
end
