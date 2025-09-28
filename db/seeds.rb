# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# rubocop:disable Rails/Output
puts '🌱 Seeding database...'

# Create sample users
users = %w[Alice Bob Charlie Diana Eve].map do |name|
  User.find_or_create_by!(name: name)
end

puts "✅ Created #{users.count} users"

puts '🌱 Seeding done!'
# rubocop:enable Rails/Output
