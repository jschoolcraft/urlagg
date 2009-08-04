class AddTaggingsCountToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :taggings_count, :integer
    
    Tag.reset_column_information
    Tag.find(:all).each do |tag|
      Tag.update_counters tag.id, :taggings_count => tag.taggings.length
    end
  end

  def self.down
    remove_column :tags, :taggings_count
  end
end
