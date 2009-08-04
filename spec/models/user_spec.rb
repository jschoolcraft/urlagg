require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  
  def create_user
    @user ||= User.create(@valid_attributes)
  end
  
  before(:each) do
    @valid_attributes = {
      :login => "value for login",
      :email => "something@domain.com",
      :password => "secret",
      :password_confirmation => "secret",
      :crypted_password => "value for crypted_password",
      :persistence_token => "value for persistence_token",
      :login_count => 1,
      :last_request_at => Time.now,
      :last_login_at => Time.now,
      :current_login_at => Time.now,
      :last_login_ip => "value for last_login_ip",
      :current_login_ip => "value for current_login_ip"
    }
  end

  it "should create a new instance given valid attributes" do
    create_user
  end
  
  it "should output the login for to_s" do
    user = User.new(@valid_attributes)
    user.to_s.should == user.login
  end
    
  describe "tracking new tags" do
    before do
      @user = User.create!(@valid_attributes)
    end
    
    it "should add the tracked tag to the collection" do
      @user.track_tag("foo")
      @user.tags.map(&:name).include?("foo").should be_true
    end
    
    it "should add a new tracked tag if user is first to track this tag" do
      lambda {
        @user.track_tag("tag_name")
      }.should change(Tag, :count).by(1)      
    end
    
    it "should not add invalid tags" do
      lambda {
        @user.track_tag(nil)
      }.should_not change(Tag, :count)
    end
    
  end
  
  describe "tracking existing tags" do
    before do
      @user = User.create!(@valid_attributes)
      Tag.create!(:name => "foo")
    end
    
    it "should not add a new tracked tag if another user tracks same tag" do 
      lambda {
        @user.track_tag("foo")
      }.should_not change(Tag, :count)
    end
  end

  describe "untracking tags that more than one user is following" do
    before do
      @user = User.create!(@valid_attributes)
      @tag = @user.track_tag("foo")
      @user.track_tag("bar")
    end
    
    it "should remove the tag from the collection" do
      lambda {
        @user.untrack_tag(@tag.id)
      }.should change(@user.tags, :count).by(-1)
    end
    
    it "should not remove an invalid tag" do
      lambda {
        @user.untrack_tag(-1)
      }.should_not change(@user.tags, :count)
    end
    
    it "should return the tag it stopped tracking" do
      tag = Tag.find_by_name("foo")
      returned_tag = @user.untrack_tag(tag.id)
      returned_tag.should == tag
    end
  end
  
  describe "#tags_with_unread_links" do
    before do
      create_user
      @user.update_attributes(:last_viewed_tags_index_at => 2.hours.ago)
      
      @ruby = @user.track_tag('ruby')
      @grails = @user.track_tag('grails')
      @gtd = @user.track_tag('gtd')
      
      @ruby_1 = Link.create(:title => 'Ruby 1', :url => 'http://ruby-1', :created_at => 1.days.ago )
      @ruby_2 = Link.create(:title => 'Ruby 2', :url => 'http://ruby-2')

      @ruby.links << @ruby_1    
      @ruby.links << @ruby_2
      
      @grails.links << @ruby_2
    end
    
    it "should only return tags that have unread links" do
      pending
    end
  end

  describe "latest_popular_links" do
    before do
      create_user
      
      @link_1 = Link.create!(:url => "http://link-1", :created_at => 1.day.ago)
      @link_2 = Link.create!(:url => "http://link-2", :created_at => 1.hour.ago)
      @link_3 = Link.create!(:url => "http://link-3", :created_at => 1.minute.ago)
      
      @ruby   = Tag.create!(:name => 'ruby')
      @gtd    = Tag.create!(:name => 'gtd')
      @rails  = Tag.create!(:name => 'rails')
      
      @user.tags << @ruby << @gtd << @rails
    end
    
    it "returns all the links with most recent link first" do
      @link_1.tags << @ruby
      @link_2.tags << @gtd
      @link_3.tags << @rails
      
      @user.latest_popular_links.should == ([@link_1, @link_2, @link_3].sort { |a,b| b.created_at <=> a.created_at })
    end
    
    it "returns all the links tagged with at least on of the user's tracked tags" do
      @link_1.tags << @ruby
      @link_2.tags << @gtd
      @link_3.tags << @rails
      
      [@link_1, @link_2, @link_3].each do |link|
        @user.latest_popular_links.include?(link).should be_true
      end
    end
    
    it "should return a link once even if that link is tagged by more than one tracked tag" do
      @link_1.tags << @ruby << @rails
      @user.latest_popular_links.should == [@link_1]
    end
    
    it "should not return more than 30 links by default" do
      (1..50).each { |i| Link.create!(:url => "http://foo-#{i}.com").tags << @ruby }
      @user.latest_popular_links.size.should == 30
    end
    
    it "should limit the results with the limit is specified" do
      (1..50).each { |i| Link.create!(:url => "http://foo-#{i}.com").tags << @ruby }
      @user.latest_popular_links(:limit => 5).size.should == 5
    end
  end
  
  describe "#todays_links" do
    before(:each) do
      create_user
      
      @link_1 = Factory.create(:bookmarked_link, :created_at => 36.hours.ago)
      @link_2 = Factory.create(:bookmarked_link, :created_at => 1.hour.ago)
      @link_3 = Factory.create(:bookmarked_link, :created_at => 1.minute.ago)
      
      @ruby   = Tag.create!(:name => 'ruby')
      @gtd    = Tag.create!(:name => 'gtd')
      @rails  = Tag.create!(:name => 'rails')
      
      @link_1.tags << @ruby
      @link_2.tags << @gtd
      @link_3.tags << @rails
      
      @user.tags << @ruby << @gtd << @rails
    end
    
    it "builds a hash with tags as keys and link array as values for today's links" do
      links, latest = @user.todays_links
      links.should == [
        [@gtd, [@link_2]],
        [@rails, [@link_3]]
      ]
      latest.to_s.should == @link_3.updated_at.to_s
    end
  end
end
