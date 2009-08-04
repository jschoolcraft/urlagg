require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TaggingsController do

  def mock_tag(stubs={})
    @mock_tag ||= mock_model(Tag, stubs)
  end
  
  describe "POST create" do
  
    before do
      login
      @tag = mock_tag(:name => 'foo', :new_record? => false)
      current_user.stub!(:track_tag).and_return(@tag)
    end

    def do_post(options={})
      post :create, options
    end

    it "tracks the new tag and assigns it for the view" do
      current_user.should_receive(:track_tag).with('foo').and_return(@tag)
      do_post(:tag => { :name => 'foo' })
      assigns[:tag].should == @tag
    end

    describe "with valid params" do
      it "assigns flash[:notice]" do
        do_post
        flash[:notice].should_not be_nil
      end

      it "redirects to the tags index" do
        do_post
        response.should redirect_to(tags_path)
      end
    end

    describe "with invalid params" do
      before do
        @tag.stub!(:new_record?).and_return(true)
      end

      it "redirects to the index template" do
        do_post(:tag => {:name => nil })
        response.should redirect_to(tags_path)
      end

    end  

  end

  describe "DELETE destroy" do
    
    before do
      login
      @tag = mock_tag(:name => 'foo')
      current_user.stub!(:untrack_tag).and_return(@tag)
    end
    
    def do_delete(options = {})
      delete :destroy, ({:id => 'a_tag'}).merge(options)
    end
    
    it "stops tracking the tag" do
      current_user.should_receive(:untrack_tag).with('foo').and_return(@tag)
      do_delete(:id => 'foo')
    end
    
    it "sets the flash" do
      do_delete
      flash[:notice].should_not be_nil
    end
    
    it "redirects to tags index" do
      do_delete
      response.should redirect_to(tags_path)
    end
  end 
end
