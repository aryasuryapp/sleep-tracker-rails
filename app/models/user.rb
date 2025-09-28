# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true

  has_many :sleep_records, dependent: :destroy
end
