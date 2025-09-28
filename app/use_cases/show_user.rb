# frozen_string_literal: true

# app/use_cases/show_user.rb
class ShowUser
  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  def call(id)
    @user_repository.find(id)
  end
end
