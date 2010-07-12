class Link < ActiveRecord::Base
  BOOKMARKS_THRESHOLD = 1000
  URLINFO_URL = "http://feeds.delicious.com/v2/json/urlinfo/%s"
  
  has_many :tagged_links
  has_many :tags, :through => :tagged_links
  validates_presence_of :url
  
  # scope :today, :conditions => ["links.created_at > ?", Date.today.to_time], :order => "links.created_at desc"
  scope :latest, :limit => 10, :order => "links.created_at desc"
  class << self
    def count_bookmarks(above)
      self.count(:all, :conditions => ['links.bookmarks > ?', above])
    end
    
    def threshold
      BOOKMARKS_THRESHOLD
    end
    
    def needing_bookmarks_updated(threshold=Link.threshold, freshness=1.week.ago, limit=200)
      self.all(
        :conditions => [ "(links.bookmarks <= ? AND links.updated_at >= ?)", threshold, freshness],
        :order => "links.bookmarks ASC, links.updated_at DESC",
        :limit => limit
      )
    end
    
    def pause_updates
      Configuration.dont_update_bookmarks_before = 1.hour.from_now
    end
    
    def can_run_updates?
      Configuration.dont_update_bookmarks_before < Time.now
    end
  end
  
  def source_tags=(new_tags)
    write_attribute(:source_tags, new_tags.join(','))
  end
  
  def source_tags
    (read_attribute(:source_tags) || '').split(',')
  end
  
  def update_bookmarks_count
    digest = Digest::MD5.hexdigest(url)
    begin
      response = open(URLINFO_URL % digest, "User-Agent" => "urlagg/1.0").read
      json = JSON.parse(response)
      self.update_attributes(:bookmarks => json[0] && json[0]['total_posts'])
    rescue OpenURI::HTTPError => e
      HoptoadNotifier.notify(:error_message => e)
      false
    end
  end
end
