require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::LinksController do
  before(:each) do
    admin_login
  end

  describe "get reports" do
    before(:each) do
      admin_login
      Link.stub!(:count).and_return(-1)
    end
    
    def do_get
      get :reports #reports_admin_link_path
    end
    
    it "assigns stats for the view" do
      Link.should_receive(:count).exactly(3).times
      do_get
      assigns[:links_without_bookmarks].should == -1
      assigns[:links_with_bookmarks].should == -1
      assigns[:links_pending_update].should == -1
      assigns[:links_with_nil_bookmarks].should == -1
    end
    
    it "assigns distributions array for the view" do
      Link.should_receive(:count_bookmarks).with(500).and_return(99)
      Link.should_receive(:count_bookmarks).with(1000).and_return(0)
      do_get
      assigns[:distributions].should == [[500, 99]]
    end
    
    it "renders the view" do
      do_get
      response.should render_template('reports')
    end
  end
end
