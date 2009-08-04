class AddHotToAllUsers < ActiveRecord::Migration
  def self.up
    User.all.each do |u|
      u.track_tag("hot")
    end
  end

  def self.down
  end
end
