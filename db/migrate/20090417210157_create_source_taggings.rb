class CreateSourceTaggings < ActiveRecord::Migration
  def self.up
    create_table :source_taggings do |t|
      t.references :link
      t.references :source_tag
      t.integer :position
      t.timestamps
    end
    
    add_index :source_taggings, :link_id
    add_index :source_taggings, :source_tag_id
  end

  def self.down
    remove_index :source_taggings, :link_id
    remove_index :source_taggings, :source_tag_id

    drop_table :source_taggings
  end
end