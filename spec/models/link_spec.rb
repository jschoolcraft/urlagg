require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Link do

  # it { should have_column :bookmarks, :type => :integer }
  # it { should have_column :last_seen_in_feed, :type => :datetime }
  # it { should have_column :source_tags, :type => :text }

  before(:each) do
    @link = mock_model(Link)
    @valid_attributes = {
      :url => "http://example.com",
      :title => "Example Home Page",
      :summary => "this is a summary of the page, should probably only be the first 100 characters or so..." 
    }
  end

  it "should create a new instance given valid attributes" do
    Link.create!(@valid_attributes)
  end

  it "should not create a new link with invalid attributes" do
    @link = Link.create(@valid_attributes.merge({:url => nil }))
    @link.should_not be_valid
  end

  describe "count links with bookmarks" do
    before(:each) do
      1.upto(10) { Factory.create(:link, :bookmarks => 5) }
    end
    
    it "counts the links with bookmarks above a threshold" do
      Link.count_bookmarks(4).should == 10
    end
  end

  describe "adding new source tags" do

    it "should add source tags as a comma separated list" do
      @link = Link.create!(@valid_attributes.merge(:source_tags => ['tag1', 'tag2']))
      @link.source_tags.should == ['tag1', 'tag2']
    end
  end
  
  describe "updating the bookmark count" do
    before(:each) do
      @link = Factory.create(:link)
      @json_file = open(File.join(Rails.root, '/spec/fixtures/delicious/urlinfo.json'))
      @link.stub!(:open).and_return(@json_file)
    end

    it "fetches the URL info page" do
      @link.should_receive(:open).with(Link::URLINFO_URL % Digest::MD5.hexdigest(@link.url), "User-Agent" => "urlagg/1.0").and_return(@json_file)
      @link.update_bookmarks_count
    end
    
    it "updates the bookmarks count" do
      @link.should_receive(:update_attributes).with(:bookmarks => 19054)
      @link.update_bookmarks_count
    end
    
    it "does not update the bookmarks count if the response is an HTTP error" do
      @link.should_receive(:open).and_raise(OpenURI::HTTPError.new('503 Service unavailable', @json_file))
      @link.should_not_receive(:update_attributes)
      @link.update_bookmarks_count
    end
    
    it "logs the HTTP error through Hoptoad" do
      e = OpenURI::HTTPError.new('503 Service unavailable', @json_file)
      @link.should_receive(:open).and_raise(e)
      HoptoadNotifier.should_receive(:notify).with(:error_message => e)
      @link.update_bookmarks_count
    end
  end
  
  describe "running an update bookmark count job" do
    before(:each) do
      @link1 = Factory.create(:link)
      @link2 = Factory.create(:link)
      @link3 = Factory.create(:link)
      @links = [@link3, @link2, @link1]
      
      Link.stub!(:needing_bookmarks_updated).and_return(@links)
      @links.each do |link|
        link.stub!(:update_bookmarks_count).and_return(true)
      end
      
      Link.stub!(:update_bookmarks_count).and_return(true)
    end
  end
  
  describe "can_run_updates?" do
    it "returns true if the dont_update_bookmarks_before config value is in the past" do
      @time = 1.hour.ago
      Configuration.should_receive(:dont_update_bookmarks_before).and_return(@time)
      Link.can_run_updates?.should be_true
    end
    
    it "returns false if the dont_update_bookmarks_before config value is in the future" do
      @time = 1.hour.from_now
      Configuration.should_receive(:dont_update_bookmarks_before).and_return(@time)
      Link.can_run_updates?.should be_false
    end
  end
  
  describe "pause_updates" do
    it "configures the next time the update job can resume" do
      Configuration.should_receive(:dont_update_bookmarks_before=).with(a_kind_of(Time))
      Link.pause_updates
    end
  end
  
  describe "needing_bookmarks_update named scope" do
    before do
      @link1 = Factory.create(:link, :title => 'link-1', :bookmarks => 0, :last_seen_in_feed => Time.now, :updated_at => Time.now)
      @link2 = Factory.create(:link, :title => 'link-2', :bookmarks => 5, :last_seen_in_feed => 1.day.ago, :updated_at => 1.day.ago)
      @link3 = Factory.create(:link, :title => 'link-3', :bookmarks => 10, :last_seen_in_feed => 2.days.ago, :updated_at => 2.days.ago)
      @link4 = Factory.create(:link, :title => 'link-4', :bookmarks => 100, :last_seen_in_feed => 3.days.ago, :updated_at => 3.days.ago)
      @link5 = Factory.create(:link, :title => 'link-5', :bookmarks => 10, :last_seen_in_feed => 1.month.ago, :updated_at => 1.month.ago)
    end
    
    it "finds links with bookmarks below a threshold ordered by newest first" do
      Link.needing_bookmarks_updated(50, 1.week.ago, 60).should == [@link1, @link2, @link3]
    end
    
    it "finds links with last_seen_in_feed within a fresh time period" do
      Link.needing_bookmarks_updated(50, 36.hours.ago, 60).should == [@link1, @link2]
    end
    
    it "has a limit" do
      Link.needing_bookmarks_updated(50, 1.week.ago, 1).size.should == 1
    end
  end
end
