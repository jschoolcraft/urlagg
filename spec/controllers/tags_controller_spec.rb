require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do
  it "requires login for tracked tags" do
    get :index
    response.should redirect_to(new_user_session_path)
  end
  
  describe "GET index" do
    before do
      login
      @recent_taggings = (1..3).map { mock_model(Tag) }
      Tag.stub!(:recent_taggings).and_return(@recent_taggings)
    end
    
    def do_get
      get :index
    end

    it "should find the current user and assign it for the view" do
      do_get
      assigns[:user].should == current_user
    end
    
    it "should create a new tag and assign it for the view" do
      Tag.should_receive(:new).and_return(@tag = mock_model(Tag))
      do_get
      assigns[:tag].should == @tag
    end
    
    it "should find the users tags and assign it for the view" do
      @tags = [ mock_model(Tag) ]
      current_user.should_receive(:tags).and_return(@tags)
      do_get
      assigns[:tags].should == @tags
    end
    
    it "assigns recent taggings for the view" do
      Tag.should_receive(:recent_taggings).and_return(@recent_taggings)
      do_get
      assigns[:recent_taggings].should == @recent_taggings
    end
    
    it "should render the index template" do
      do_get
      response.should render_template('index')
    end
  end
  
  describe "GET show for HTML" do
    before do
      @tag = mock_model(Tag, :links => mock("tag.links"))
      Tag.stub!(:find_by_name).and_return(@tag)
      Tag.stub!(:find).and_return(@tag)
      
      @tags = [@tag]
      current_user.stub!(:tags).and_return(@tags)
      
      @recent_taggings = (1..3).map { mock_model(Tag) }
      Tag.stub!(:recent_taggings).and_return(@recent_taggings)
      
      @links = (1..10).map { mock_model(Link) }
      @tag.links.stub!(:paginate).and_return(@links)      
    end
    
    def do_get(options={})
      get :show, {:id => '1-ruby'}.update(options)
    end
    
    it "is successful" do
      do_get
      response.should be_success
    end
  
    it "does not require login for showing links for a tag" do
      do_get
      response.should be_success
    end
    
    it "if it finds the specified tag then assigns it for the view" do
      Tag.should_receive(:find_by_name).with("a_tag").and_return(@tag)
      do_get(:id => nil, :tag => 'a_tag')
      assigns[:tag].should == @tag
    end
    
    it "finds the specified tag by id if tag name not specified" do
      Tag.should_receive(:find).with("1-ruby").and_return(@tag)
      do_get
      assigns[:tag].should == @tag      
    end
    
    it "fetches a paginated links collection with 20 per page and assigns it for the view" do
      @tag.links.should_receive(:paginate).with(:page => 3, :per_page => 20).and_return(@links)
      do_get(:page => 3)
      assigns[:links].should == @links
    end
    
    it "fetches the first page if the page parameter is not in the correct format" do
      @tag.links.should_receive(:paginate).with(:page => 1, :per_page => 20).and_return(@links)
      do_get(:page => 'asdfaf')
      assigns[:links].should == @links
    end
    
    it "assigns all the users tags for the view if a user is logged in" do
      login
      current_user.should_receive(:tags).and_return(@tags)
      do_get
      assigns[:tags].should == @tags
    end

    it "assigns nil to tags for the view if no user is logged in" do
      logout
      do_get
      assigns[:tags].should be_nil
    end
    
    it "assigns recent taggings for the view" do
      Tag.should_receive(:recent_taggings).and_return(@recent_taggings)
      do_get
      assigns[:recent_taggings].should == @recent_taggings
    end
    
    it "renders the show template if the tag is found by id" do
      do_get
      response.should render_template(:show)
    end
    
    it "renders the show template if the tag is found by name" do
      do_get(:id => nil, :tag => 'a_tag')
      response.should render_template(:show)
    end
    
    it "render the not_tracking template if tag is not found by name" do
      Tag.should_receive(:find_by_name).with("a_tag").and_return(nil)
      do_get(:id => nil, :tag => 'a_tag')
      response.should render_template(:not_tracking)
    end
    
    it "creates a new unsaved tag if tag is not found by name and assigns it for the view" do
      Tag.should_receive(:find_by_name).with("a_tag").and_return(nil)
      Tag.should_receive(:new).with(:name => "a_tag").and_return(@tag)
      do_get(:id => nil, :tag => 'a_tag')
      assigns[:tag].should == @tag
    end
  end
    
  describe "handling GET /show for ATOM" do
  
    before do
      @links = (1..20).map { |i| mock_model(Link, :url => "http://example-#{i}.com") } 
      @tag = stub_model(Tag, :links => mock("links", :paginate => @link))
      Tag.stub!(:find).and_return(@tag)
    end
  
    def do_get
      get :show, :id => '1', :format => 'atom'
    end
  
    it "finds the specified tag" do
      Tag.should_receive(:find).and_return(@tag)
      do_get
    end
  
    it "assigns popular links for tracked tag" do
      @tag.links.should_receive(:paginate).and_return(@links)
      do_get
    end
    
    it "should render the show atom template" do
      do_get
      response.should render_template('show')
    end
  end
    
  describe "handling GET summary.atom" do
    before do
      @tag = stub_model(Tag)
      Tag.stub!(:find).and_return(@tag)
      @links = (1..20).map { |i| mock_model(Link, :url => "http://example-#{i}.com") } 
    end
    
    def do_get
      get :summary, :id => '1', :format => 'atom'
    end
  
    it "finds the specified tag and assigns it to the view" do
      Tag.should_receive(:find).and_return(@tag)
      do_get
      assigns[:tag].should == @tag
    end
    
    it "finds today's links for the tag and assigns it to the view" do
      @tag.should_receive(:links_after).with(Date.today).and_return(@links)
      do_get
      assigns[:links].should == @links
    end
    
    it "should render the summary template" do
      do_get
      response.should render_template('summary')
    end
  end

  describe "handling GET top" do
    before do
      @tags = (1..9).map { |i| [mock_model(Tag, :name => "tag-#{i}"), (1..5).map {mock_model(Link)}] }
    end
    
    def do_get
      get :top
    end
    
    it "is successful" do
      do_get
      response.should render_template(:top)
    end
    
    it "find the new tags for the logged in user and assigns them for the view" do
      Tag.should_receive(:top).and_return(@tags)
      do_get
      assigns[:tags].should == @tags
    end
  end
  
  describe "handling POST read" do
    before(:each) do
      login({}, :tags => mock("current_user.tags"))
      @tag = mock_model(Tag)
      @tag.stub!(:mark_read_for)
      current_user.tags.stub!(:find).and_return(@tag)
    end
    
    def do_post
      post :read, :id => "37"
    end
    
    it "finds the specified tagging and assigns it for the view" do
      current_user.tags.should_receive(:find).with("37").and_return(@tag)
      do_post
    end
    
    it "updates the tagging with a timestamp" do
      @tag.should_receive(:mark_read_for).with(current_user)
      do_post
    end
    
    it "redirects to the tags index page" do
      do_post
      response.should redirect_to(tags_path)
    end
  end
end