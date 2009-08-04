class AddLastSeenAtToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :last_seen_at, :datetime
  end

  def self.down
    remove_column :taggings, :last_seen_at
  end
end
