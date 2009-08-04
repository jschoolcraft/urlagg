class DropSourceTags < ActiveRecord::Migration
  
  class ::SourceTag < ActiveRecord::Base
    has_many :source_taggings
    has_many :links, :through => :source_taggings
  end
  
  class ::SourceTagging < ActiveRecord::Base
    belongs_to :source_tag
    belongs_to :link
  end
  
  class ::Link < ActiveRecord::Base
    has_many :source_taggings
    has_many :delicious_tags, :source => :source_tag, :through => :source_taggings
  end
  
  def self.up
    add_column :links, :source_tags, :text
    Link.reset_column_information
    
    Link.find_each(:batch_size => 100) do |link|
      link.send(:write_attribute, :source_tags, link.delicious_tags.map(&:name).join(','))
      link.save
    end
    
    drop_table :source_tags
    drop_table :source_taggings
  end

  def self.down
    remove_column :links, :source_tags
    create_table "source_taggings", :force => true do |t|
      t.integer  "link_id"
      t.integer  "source_tag_id"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "source_tags", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
