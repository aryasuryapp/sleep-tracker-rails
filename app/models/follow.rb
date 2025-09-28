# frozen_string_literal: true

# app/models/follow.rb
class Follow < ApplicationRecord
  # Validations
  validates :follower_id, uniqueness: { scope: :followed_id }

  # Associations
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end
