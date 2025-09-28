# frozen_string_literal: true

# app/use_cases/unfollow_user.rb
class UnfollowUser
  def initialize(follower:, followed:)
    @follower = follower
    @followed = followed
  end

  def call
    follow = Follow.find_by(follower: @follower, followed: @followed)
    follow&.destroy
  end
end
