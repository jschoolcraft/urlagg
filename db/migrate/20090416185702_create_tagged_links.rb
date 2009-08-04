class CreateTaggedLinks < ActiveRecord::Migration
  def self.up
    create_table :tagged_links, :force => true do |t|
      t.references :tag
      t.references :link
      
      t.timestamps # created_at => first seen, updated_at => last seen
    end
    add_index :tagged_links, :tag_id
    add_index :tagged_links, :link_id
  end

  def self.down
    remove_index :tagged_links, :link_id
    remove_index :tagged_links, :tag_id
    drop_table :tagged_links
  end
end
