class CreateSourceTags < ActiveRecord::Migration
  def self.up
    create_table :source_tags do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :source_tags
  end
end
