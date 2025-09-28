# frozen_string_literal: true

# app/repositories/user_repository.rb
class UserRepository
  def all
    User.all
  end

  def find(id)
    User.find(id)
  end

  def followers(user_id)
    User.find(user_id).followers
  end

  def following(user_id)
    User.find(user_id).following
  end
end
