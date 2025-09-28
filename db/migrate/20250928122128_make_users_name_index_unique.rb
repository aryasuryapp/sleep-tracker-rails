# frozen_string_literal: true

# Make the index on users.name unique
class MakeUsersNameIndexUnique < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, :name
    add_index :users, :name, unique: true
  end
end
