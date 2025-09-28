# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true

  has_many :sleep_records, dependent: :destroy

  has_many :follower_relationships, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy,
                                    inverse_of: :followed
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy,
                                     inverse_of: :follower
  has_many :following, through: :following_relationships, source: :followed
end
