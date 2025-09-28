# frozen_string_literal: true

# app/use_cases/list_users.rb
class ListUsers
  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  def call
    @user_repository.all
  end
end
