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

require 'faker'

# rubocop:disable Rails/Output
puts '🌱 Seeding database...'

# Create sample users
users = %w[Alice Bob Charlie Diana Eve].map do |name|
  User.find_or_create_by!(name: name)
end

puts "✅ Created #{users.count} users"

# Create random sleep records for past 7 days
users.each do |user|
  5.times do
    start_time = Faker::Time.between(from: 7.days.ago, to: Time.zone.now)
    duration = rand(5..9) # hours
    end_time = start_time + duration.hours

    SleepRecord.create!(
      user: user,
      start_time: start_time,
      end_time: end_time
    )
  end
end

puts "✅ Created #{SleepRecord.count} sleep records"

puts '🌱 Seeding done!'
# rubocop:enable Rails/Output
