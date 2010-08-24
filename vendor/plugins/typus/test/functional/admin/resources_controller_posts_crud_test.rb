require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  should "render index" do
    get :index
    assert_response :success
    assert_template 'index'
  end

  should "render new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  should "create" do
    assert_difference 'Post.count' do
      post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
      assert_response :redirect
      assert_redirected_to :controller => 'admin/posts', :action => 'edit', :id => Post.last
    end
  end

  should "render show" do
    get :show, { :id => Factory(:post).id }
    assert_response :success
    assert_template 'show'
  end

  should "render edit" do
    get :edit, { :id => Factory(:post).id }
    assert_response :success
    assert_template 'edit'
  end

  should "update" do
    _post = Factory(:post)
    post :update, { :id => _post.id, :title => 'Updated' }
    assert_response :redirect
    assert_redirected_to :controller => 'admin/posts', :action => 'edit', :id => _post.id
  end

end
