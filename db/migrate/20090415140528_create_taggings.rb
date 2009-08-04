class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings, :force => true do |t|
      t.references :user
      t.references :tag
      t.integer :position
      t.timestamps
    end

    add_index :taggings, :user_id
    add_index :taggings, :tag_id
    
    remove_column :tags, :position
    remove_column :tags, :user_id
  end

  def self.down
    remove_index :taggings, :tag_id
    remove_index :taggings, :user_id

    add_column :tags, :position, :integer
    add_column :tags, :user_id, :integer
    drop_table :taggings
  end
end
