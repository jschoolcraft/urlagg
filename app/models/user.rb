class User < ActiveRecord::Base
  acts_as_authentic  
  has_many :taggings
  has_many :tags, :through => :taggings
  
  def track_tag(tag_name)
    @tag = Tag.find_by_name(tag_name)
    if @tag
      self.tags << @tag unless tags.include?(@tag)
    else
      @tag = Tag.new(:name => tag_name)
      if @tag.save
        self.tags << @tag
      end
    end
    @tag
  end
  
  def untrack_tag(id)
    if tags.exists?(id)
      @tag = tags.find(id) 
      tags.delete(@tag)
      @tag
    end
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def to_s
    self.login
  end
  
  def update_password_attributes(attributes)
    update_attributes(attributes.delete_if {|key, val| key.to_sym != :password && key.to_sym != :password_confirmation})
  end
  
  def latest_popular_links(options={})
    popular_links(:limit => options[:limit] || 30)
  end
  
  def todays_links
    all_links = []
    most_recent = Tag.new(:updated_at => 1.year.ago)
    tags.ascending.each do  |tag|
      links = tag.todays_links
      most_recent = links.inject(most_recent) {|most_recent, link| link.updated_at > most_recent.updated_at ? link : most_recent }
      all_links << [tag, links] unless links.empty?
    end
    [all_links, most_recent.updated_at]
  end
  
  private
  def popular_links(options={})
    conditions_str  = ["users.id = ?"]
    conditions_args = [self.id]
    
    conditions = [conditions_str.join(' AND '), *conditions_args]
    
    Link.find(:all, :group => 'links.id',
      :joins => %Q{
            LEFT OUTER JOIN `tagged_links` ON tagged_links.link_id = links.id 
            LEFT OUTER JOIN `tags` ON `tags`.id = `tagged_links`.tag_id 
            LEFT OUTER JOIN `taggings` ON taggings.tag_id = tags.id 
            LEFT OUTER JOIN `users` ON `users`.id = `taggings`.user_id
          }, 
      :limit => options[:limit], :conditions => conditions, :order => "links.created_at desc")
  end
end
