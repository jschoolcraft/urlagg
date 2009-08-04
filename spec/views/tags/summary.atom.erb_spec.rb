require File.dirname(__FILE__) + '/../../spec_helper'

describe 'GET /tag/summary.atom.erb' do
  before(:each) do
    @tag_1 = stub_model(Tag, :name => 'tag_1')
    @tag_2 = stub_model(Tag, :name => 'tag_2')
    @tag_3 = stub_model(Tag, :name => 'tag_3')
    
    @links = (1..20).map { |l| mock_model(Link, 
                                :created_at => l.hours.ago, 
                                :updated_at => l.hours.ago,
                                :title => "link-#{l}", 
                                :url => "http://example-#{l}.com/bar", 
                                :tags => (1..3).map { |t| stub_model(Tag, :name => "tag-#{t}-for-link-#{l}") } )}

    @tag_1.stub!(:todays_links).and_return(@links)

    assigns[:tag] = @tag_1
    assigns[:links] = @links
    
    do_render
  end
  
  def do_render
    render "/tags/summary.atom.erb"
    @feed = Atom::Feed.load_feed(response.body)
  end

  it "has a proper title" do
    @feed.title.should == "[urlagg] tag_1 summary"
  end
  
  it "has the last modified date set to the latest link's created_at date" do
    latest = @links.max { |a,b| a.created_at <=> b.created_at }
    @feed.updated.to_s(:short).should == latest.created_at.to_s(:short)
  end
  
  it "sets links to the feed url (atom and html)" do
    @feed.links.map(&:href).include?("http://test.host/tags/#{@tag_1.to_param}/summary.atom").should be_true
  end
  
  it "has a proper feed id" do
    @feed.id.should == "urlagg.com:tag_links:tag_1:summary"
  end
  
  it "should have 1 feed entries" do
    @feed.entries.size.should == 1
  end

  describe "atom entry" do
    before(:each) do
      @entry = @feed.entries.first
    end
  
    it "should have a proper id" do
      @entry.id.should == "urlagg.com:tag_links:tag_1:summary:#{Date.today}"
    end
    
    it "should set the title properly" do
      @entry.title.should == "[urlagg] #{Date.today} - Links for tag_1"
    end
    
    it "sets entry updated date to link's updated date" do
      latest = @links.max { |a,b| a.created_at <=> b.created_at }
      @entry.updated.to_s(:short).should == latest.created_at.to_s(:short)
    end

    it "renders the link.atom.erb partial" do
      pending
      template.should_receive(:render).with(:partial => 'link.atom.erb', :collection => @tag_1.links.today, :locals => { :tag => @tag_1}).and_return("rendered_link.atom.erb")
      @entry.content.to_s.should =~ /rendered_link.atom.erb/
    end
    
    it "sets the content properly" do
      content = @entry.content.to_s
      
      content.should have_tag("div.tag") do
        with_tag("h3", "Popular links seen on #{Date.today} for tag_1")
      end
    end
  end
end
