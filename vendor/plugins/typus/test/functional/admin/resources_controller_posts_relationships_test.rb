require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  ##
  # Post => has_many :comments
  ##

  should "relate_comment_with_post_and_then_unrelate" do

    comment = Factory(:comment, :post => nil)
    post_ = Factory(:post)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#comments"

    assert_difference('post_.comments.count') do
      post :relate, { :id => post_.id,
                      :related => { :model => 'Comment', :id => comment.id } }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Comment related to Post", flash[:notice]

    assert_difference('post_.comments.count', -1) do
      post :unrelate, { :id => post_.id,
                        :resource => 'Comment', :resource_id => comment.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Comment unrelated from Post", flash[:notice]

  end

  ##
  # Post => has_and_belongs_to_many :categories
  ##

  should "relate_category_with_post_and_then_unrelate" do

    category = Factory(:category)
    post_ = Factory(:post)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#categories"

    assert_difference('category.posts.count') do
      post :relate, { :id => post_.id,
                      :related => { :model => 'Category', :id => category.id } }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Category related to Post", flash[:notice]

    assert_difference('category.posts.count', -1) do
      post :unrelate, { :id => post_.id,
                        :resource => 'Category', :resource_id => category.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Category unrelated from Post", flash[:notice]

  end

=begin

  ##
  # Post => has_many :assets, :as => resource (Polimorphic)
  ##

  # FIXME: ActiveRecord::UnknownAttributeError: unknown attribute: post
  should "relate_asset_with_post_and_then_unrelate"

    post_ = Factory(:post)

    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#assets"

    assert_difference('post_.assets.count', -1) do
      get :unrelate, { :id => post_.id,
                       :resource => 'Asset', :resource_id => post_.assets.first.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Asset unrelated from Post.", flash[:notice]

  end

=end

end
