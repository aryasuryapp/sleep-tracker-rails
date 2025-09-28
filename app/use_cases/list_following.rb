# frozen_string_literal: true

# app/use_cases/list_following.rb
class ListFollowing
  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  def call(user_id)
    @user_repository.following(user_id)
  end
end
