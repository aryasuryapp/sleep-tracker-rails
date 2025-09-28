# frozen_string_literal: true

# app/use_cases/unfollow_user.rb
class UnfollowUser
  include Dry::Monads[:result]

  def initialize(follower:, followed:)
    @follower = follower
    @followed = followed
  end

  def call
    follow = Follow.find_by(follower: @follower, followed: @followed)
    return Failure("Not following user with ID #{@followed.id}") if follow.nil?

    follow.destroy!
    Success('Unfollowed successfully!')
  end
end
