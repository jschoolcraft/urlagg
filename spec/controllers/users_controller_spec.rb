require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  before(:each) do
    @user = stub_model(User)
    User.stub!(:find).and_return(@user)
    @user.stub!(:todays_links)
    
    @links = {}
    (1..3).map { |i| @links[stub_model(Tag, :name => 'tag_#i')] = (1..10).map { |l| stub_model(Link, :title => "Link for tag_#{i}", :url => "http://www.example-#{l}.com") } } 
  end
  
  describe "handling GET show.atom" do
    before do
      @user.stub!(:latest_popular_links).and_return([])
      @links = (1..20).map { |l| mock_model(Link, 
                                  :created_at => l.hours.ago, 
                                  :title => "link-#{l}", 
                                  :url => "http://example-#{l}.com/bar", 
                                  :tagged_links => [ mock_model(TaggedLink, 
                                  :tag => mock_model(Tag, :name => "foo-#{l}")) ] )}
    end
    
    def do_get
      get :show, :id => @user.id, :format => 'atom'
    end
    
    it "finds the specified user" do
      User.should_receive(:find).and_return(@user)
      do_get
    end
    
    it "assigns popular links for all tracked tags" do
      @user.should_receive(:latest_popular_links).and_return(@links)
      do_get
    end
  end
  
  describe "handling GET show.html" do
  end
  
  describe "handling GET summary.atom" do
    def do_get
      get :summary, :id => @user.id, :format => 'atom'
    end
    
    it "finds the specified user and assigns it to the view" do
      User.should_receive(:find).and_return(@user)
      do_get
      assigns[:user] == @user
    end
    
    it "finds all of today's links and latest_update and assigns them to the view" do
      @user.should_receive(:todays_links).and_return([@links, @latest_update])
      do_get
      assigns[:links] == @links
      assigns[:latest_update] == @latest_update
    end
    
    it "renders the summary templates" do
      do_get
      response.should render_template('summary.atom.erb')
    end
  end

  describe "handling UPDATE" do

    def do_update(options={})
      login
      put :update, :id => "1"
    end

    it "should only update last_viewed_tags_index_at" do
      pending
      current_user.should_receive(:update_attributes).with(:last_viewed_tags_index_at => Time.now).and_return(true)
      do_update
    end

  end

end