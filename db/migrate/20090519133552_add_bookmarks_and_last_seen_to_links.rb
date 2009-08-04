class AddBookmarksAndLastSeenToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :bookmarks, :integer, :default => 0
    add_column :links, :last_seen_in_feed, :datetime, :default => Time.now
  end

  def self.down
    remove_column :links, :last_seen_in_feed
    remove_column :links, :bookmarks
  end
end
