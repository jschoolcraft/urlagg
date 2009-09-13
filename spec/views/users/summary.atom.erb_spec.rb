require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/summary.atom.erb" do
  before(:each) do
    @user = mock_model(User, :login => 'bob')
    
    @tags_with_links = {}
    (1..3).each do |t|
      tag = mock_model(Tag, :name => "tag_#{t}" )
       # mock("links_for_tag_#{t}")
      @tags_with_links[tag] =(1..5).map { |l|
        mock_model(Link, :title => "link-#{l}-for-tag-#{t}",
          :url => "http://www.example-#{l}-for-#{t}.com",
          :tags => [
            tag,
            mock_model(Tag, :name => "another_tag_for-#{t}-#{l}"),
            mock_model(Tag, :name => "another_tag_for-#{t}-#{l*2}")],
          :created_at => l.hours.ago) }      
    end
    
    @latest_update = 2.minutes.ago
    
    assigns[:user] = @user
    assigns[:latest_update] = @latest_update
    assigns[:tags_with_links] = @tags_with_links
    do_render
  end
  
  def do_render
    render "/users/summary.atom.erb", :helper => :tags
    @feed = Atom::Feed.load_feed(response.body)
  end

  it "has a proper title" do
    @feed.title.should == "[urlagg] Daily summary for bob"
  end
  
  it "has the last modified date set to the latest link's created_at date" do
    @feed.updated.to_s(:short).should == @latest_update.to_s(:short)
  end
  
  it "sets links to the feed url (atom and html)" do
    @feed.links.map(&:href).include?("http://test.host/users/#{@user.id}/summary.atom").should be_true
  end
  
  it "has a proper feed id" do
    @feed.id.should == "urlagg.com:user_links:bob:summary"
  end
  
  it "should have many feed entries" do
    @feed.entries.size.should == 1
  end
  
  describe "atom entry" do
    before(:each) do
      @entry = @feed.entries.first
    end
  
    it "should have a proper id" do
      @entry.id.should == "urlagg.com:user_links:bob:summary:#{Date.today}"
    end
    
    it "should set the title properly" do
      @entry.title.should == "[urlagg] #{Date.today} - Links for bob"
    end
    
    it "sets entry updated date to link's updated date" do
      @entry.updated.to_s(:short).should == @latest_update.to_s(:short)
    end
    
    it "renders the tags/link.atom.erb partial" do
      pending
      template.should_receive(:render).with(:partial => 'tags/link.atom.erb').and_return("rendered_link.atom.erb")
      @entry.content.to_s.should =~ /rendered_link.atom.erb/
    end
    
    it "sets the content properly" do
      content = @entry.content.to_s
      @tags_with_links.each do |tag, links|
        content.should have_tag("div.tag") do
          with_tag('h3', "#{tag.name}")
        end
      end
    end
  end
end
