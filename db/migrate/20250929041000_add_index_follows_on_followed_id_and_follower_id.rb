class AddIndexFollowsOnFollowedIdAndFollowerId < ActiveRecord::Migration[7.1]
  def change
    add_index :follows, [:followed_id, :follower_id], name: 'index_follows_on_followed_id_and_follower_id'
  end
end
