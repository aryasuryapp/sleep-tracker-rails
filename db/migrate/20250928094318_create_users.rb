# frozen_string_literal: true

# Create users table with necessary fields and indexes
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
