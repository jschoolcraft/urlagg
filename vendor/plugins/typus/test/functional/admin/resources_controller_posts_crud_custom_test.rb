require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  context "Overwrite action_after_save" do

    setup do
      Typus::Resource.expects(:action_after_save).returns("index")
    end

    should "create an item and redirect to index" do
      assert_difference 'Post.count' do
        post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
        assert_response :redirect
        assert_redirected_to :action => 'index'
      end
    end

    should "update an item and redirect to index" do
      post :update, { :id => Factory(:post).id, :title => 'Updated' }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end

  end

end
