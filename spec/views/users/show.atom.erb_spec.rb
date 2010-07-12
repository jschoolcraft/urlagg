require File.dirname(__FILE__) + '/../../spec_helper'

describe 'users/show.atom.erb' do
  before(:each) do
    @user = mock_model(User, :login => 'bob')
    @links = (1..20).map { |l| mock_model(Link, 
                                :created_at => l.hours.ago, 
                                :updated_at => l.minutes.ago,
                                :title => "link-#{l}", 
                                :url => "http://example-#{l}.com/bar", 
                                :tags => (1..3).map { |t|
                                  name = "tag-#{t}-for-link-#{l}"
                                  mock_model(Tag, :to_s => name,
                                    :to_param => name, :name => name) } )}
    assign(:user, @user)
    assign(:links, @links)
    
    do_render
  end
  
  def do_render
    render
    @feed = Atom::Feed.load_feed(rendered)
  end

  it "has a proper title" do
    @feed.title.should == "[urlagg] Popular links for tags tracked by bob"
  end
  
  it "has the last modified date set to the latest link's created_at date" do
    latest = @links.max { |a,b| a.created_at <=> b.created_at }
    @feed.updated.to_s(:short).should == latest.created_at.to_s(:short)
  end
  
  it "sets links to the feed url (atom and html)" do
    @feed.links.map(&:href).include?("http://test.host/users/#{@user.id}.atom").should be_true
    @feed.links.map(&:href).include?("http://test.host/users/#{@user.id}.html").should be_true
  end
  
  it "has a proper feed id" do
    @feed.id.should == "urlagg.com:user_links:bob"
  end
  
  it "should have many feed entries" do
    @feed.entries.size.should == @links.size
  end

  describe "atom entry" do
    before(:each) do
      @entry = @feed.entries.first
      @link = @links.first
    end

    it "should have a proper id" do
      @entry.id.should == "urlagg.com:user_links:bob:#{Digest::SHA1.hexdigest(@link.url)}"
    end
    
    it "should set the title to the link title" do
      @entry.title.should == @link.title
    end
    
    it "should set the link to the link url" do
      @entry.links.map(&:href).include?(@link.url).should be_true
    end
    
    it "sets entry updated date to link's updated date" do
      @entry.updated.to_s(:short).should == @link.updated_at.to_s(:short)
    end
    
    it "sets the content properly" do
      pending "have to deal with missing have_tag matcher in rspec-rails" do
        content = @entry.content.to_s
        content.should have_tag("div.title", @link.title)
        content.should have_tag("div.url") do
          with_tag("a[href=?]", @link.url)
        end
      
        content.should have_tag("div.tags") do
          @link.tags.each do |tag|
            with_tag("a[href=?]", "http://test.host/tags/#{tag.name}")
          end
        end
      end
    end
  end
end
