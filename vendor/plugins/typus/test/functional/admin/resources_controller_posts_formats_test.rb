require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  setup do
    Post.delete_all
    @post = Factory(:post)
  end

  should "render index and return xml" do
    expected = <<-RAW
<?xml version="1.0" encoding="UTF-8"?>
<posts type="array">
  <post>
    <title>#{@post.title}</title>
    <status>#{@post.status}</status>
  </post>
</posts>
    RAW

    get :index, :format => "xml"

    assert_response :success
    assert_equal expected, @response.body
  end

  should "render index and return csv" do
    expected = <<-RAW
title;status
#{@post.title};#{@post.status}
     RAW

    get :index, :format => "csv"

    assert_response :success
    assert_equal expected, @response.body
  end

end
