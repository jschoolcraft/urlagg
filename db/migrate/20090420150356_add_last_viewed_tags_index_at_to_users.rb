class AddLastViewedTagsIndexAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_viewed_tags_index_at, :datetime
  end

  def self.down
    remove_column :users, :last_viewed_tags_index_at
  end
end
