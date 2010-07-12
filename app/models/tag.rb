class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :tagged_links
  has_many :links, :through => :tagged_links
  
  validates_presence_of :name
  validates_format_of :name, :with => /^[\w\d\.#-]+$/, :on => :create, :message => "is invalid"
  
  scope :ascending, :order => 'tags.name ASC'
  scope :top, :order => "tags.taggings_count DESC, tags.name ASC", :limit => 9
  scope :recent_taggings, :joins => :taggings, :group => "taggings.tag_id", :order => "taggings.created_at DESC", :limit => 5
  
  def to_s
    name
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def change_frequency
    'hourly'
  end
  
  def latest_popular_links(options={})
    options = {:limit => 30, :threshold => Link.threshold}.merge(options)
    self.links.find(
      :all, 
      :limit => options[:limit], 
      :order => "links.created_at desc"
    )
  end
  
  def todays_links
    links_after(Date.today)
  end
  
  def links_after(time)
    if time
      self.links.find(:all, :conditions => [ "links.created_at >= ?", time], :order => "links.created_at desc", :limit => 15)
    else                     
      self.links.find :all, :order => "links.created_at desc", :limit => 15
    end
  end

  def mark_read_for(user)
    t = taggings.for_user(user).first
    t.last_seen_at = Time.now
    t.save!
  end
end
