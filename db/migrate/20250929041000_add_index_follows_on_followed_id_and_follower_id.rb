# frozen_string_literal: true

# Migration to add an index on followed_id and follower_id in follows table
class AddIndexFollowsOnFollowedIdAndFollowerId < ActiveRecord::Migration[7.1]
  def change
    add_index :follows, %i[followed_id follower_id], name: 'index_follows_on_followed_id_and_follower_id'
  end
end
