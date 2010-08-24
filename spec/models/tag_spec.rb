require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do
   should_have_column :taggings_count, :type => :integer
   should_have_scope :ascending
   # should_have_scope :top, :order => "tags.taggings_count DESC, tags.name ASC", :limit => 9
   should_have_scope :recent_taggings

  before(:each) do
    @valid_attributes = {
      :name => "TagName"
    }
  end

  it "should render name for to_s" do
    tag = Tag.create!(@valid_attributes)
    tag.to_s.should == tag.name
  end
  
  it "should render to_param as id-name" do
    tag = Tag.create!(:name => 'ASP.NET')
    tag.to_param.should == "#{tag.id}-#{tag.name.parameterize}"
  end
  
  describe "named_scope :recent_taggings" do
    before(:each) do
      @user = Factory.create(:user)
      
      %w(ruby rails gtd foo bar baz).each_with_index do |tag_name, index|
        tag = @user.track_tag(tag_name)
        tag.taggings.find(:first, :order => 'created_at DESC').update_attributes(:created_at => index.hours.ago)
      end
    end
    
    it "finds the 5 most recent taggings of unique tags" do
      tags = Tag.recent_taggings.all
      tags.size.should == 5
      tags.first.name.should == "ruby"
      tags.map(&:name).should_not include('baz')
    end
  end

  describe "valid attributes" do
    it "should accept these names" do
      tag_names = %w[ruby ruby_on_rails asp.net c# web2.0 coding-for-fun]
      tag_names.each do |name|
        tag = Tag.new(:name => name)
        tag.should be_valid
      end
    end
    
    it "should not accept these names" do
      tag_names = %w[http://foo.com http://www.linuxdevices.com/articles/AT3782871866.html]
      tag_names.each do |name|
        tag = Tag.new(:name => name)
        tag.should_not be_valid
      end
    end
  end
  
  describe "latest_popular_links" do
    before do
      @tag = Tag.create!(@valid_attributes)
      
      @link_1 = Link.create!(:url => "http://link-1", :bookmarks => 10, :created_at => 1.day.ago)
      @link_2 = Link.create!(:url => "http://link-2", :bookmarks => 10, :created_at => 1.hour.ago)
      @link_3 = Link.create!(:url => "http://link-3", :bookmarks => 10, :created_at => 1.minute.ago)
      
      @tag.links << @link_1 << @link_2 << @link_3
    end
    
    it "returns all the links with most recent link first" do
      @tag.latest_popular_links(:threshold => 0).should == ([@link_1, @link_2, @link_3].sort { |a,b| b.created_at <=> a.created_at })
    end
    
    it "returns all the links tagged with at least one of the user's tracked tags" do
      [@link_1, @link_2, @link_3].each do |link|
        @tag.latest_popular_links(:threshold => 0).include?(link).should be_true
      end
    end
    
    it "should not return more than 30 links by default" do
      (1..50).each { |i| @tag.links << Link.create!(:url => "http://foo-#{i}.com", :bookmarks => 25) }
      @tag.latest_popular_links(:threshold => 0).size.should == 30
    end
    
    it "should limit the results with the limit is specified" do
      (1..50).each { |i| @tag.links << Link.create!(:url => "http://foo-#{i}.com") }
      @tag.latest_popular_links(:threshold => 0, :limit => 5).size.should == 5 
    end
    
    it "should only show links with bookmarks beyond the threshold" do
      @link_1.update_attributes(:bookmarks => 60)
      @tag.latest_popular_links(:threshold => 50).size.should == 3
    end
  end
  
  describe "links_after" do
    before do
      @tag = Tag.create!(@valid_attributes)
      
      @link_1 = Link.create!(:url => "http://link-1", :bookmarks => Link.threshold + 1, :created_at => 36.hours.ago)
      @link_2 = Link.create!(:url => "http://link-2", :bookmarks => Link.threshold + 1, :created_at => 1.hour.ago)
      @link_3 = Link.create!(:url => "http://link-3", :bookmarks => Link.threshold + 1, :created_at => 1.minute.ago)
      
      @tag.links << @link_1 << @link_2 << @link_3
    end
    
    it "should return all links if this is the first time a user has viewed their tags page" do
      @tag.links_after(nil).size.should == 3
    end
    
    it "returns all the links with most recent link first" do
      @tag.links_after(nil).should == ([@link_1, @link_2, @link_3].sort { |a,b| b.created_at <=> a.created_at })
    end
    
    it "returns all the links tagged with at least one of the user's tracked tags" do
      [@link_1, @link_2, @link_3].each do |link|
        @tag.links_after(nil).include?(link).should be_true
      end
    end
    
    it "should only return links after time specified" do
      @tag.links_after(5.minutes.ago).should == ([@link_3])
    end
    
    it "should not return more than 15 links by default" do
      (1..20).each { |i| @tag.links << Link.create!(:url => "http://foo-#{i}.com", :bookmarks => Link.threshold + 1) }
      @tag.links_after(nil).size.should == 15
    end
    
  end
  
  describe "today" do
    before do
      @tag = Tag.create!(@valid_attributes)
      
      @link_1 = Factory.create(:bookmarked_link, :created_at => 36.hours.ago)
      @link_2 = Factory.create(:bookmarked_link, :created_at => 1.hour.ago)
      @link_3 = Factory.create(:bookmarked_link, :created_at => 1.minute.ago)
      
      @tag.links << @link_1 << @link_2 << @link_3
    end
    
    it "returns all the links with most recent link first" do
      @tag.todays_links.should == ([@link_2, @link_3].sort { |a,b| b.updated_at <=> a.updated_at })
    end
    
    it "returns all the links tagged with at least one of the user's tracked tags" do
      [@link_2, @link_3].each do |link|
        @tag.todays_links.include?(link).should be_true
      end
    end
  end
  
  describe "mark_read_for" do
    before(:each) do
      @user = Factory.create(:user)
      @tag = Factory.create(:tag)
      
      @user.track_tag(@tag.name)
      @tagging = @tag.taggings.first
    end
    
    it "finds the tagging associated with the user" do
      @tag.taggings.should_receive(:for_user).with(@user).and_return([@tagging])
      @tag.mark_read_for(@user)
    end
    
    it "updates the last seen at timestamp" do
      lambda {
        @tag.mark_read_for(@user)
        @tagging.reload
      }.should change(@tagging, :last_seen_at)      
    end
  end
end