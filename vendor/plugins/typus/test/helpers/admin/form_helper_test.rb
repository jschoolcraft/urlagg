require "test/test_helper"

class Admin::FormHelperTest < ActiveSupport::TestCase

  include Admin::FormHelper
  include Admin::ResourcesHelper

=begin

  # FIXME: Problem with params number. A form option has to be sent.
  def test_typus_belongs_to_field

    params = { :controller => 'admin/post', :id => 1, :action => :create }
    self.stubs(:params).returns(params)

    @current_user = mock()
    @current_user.stubs(:can?).with('create', Post).returns(false)
    @resource = Comment

    expected = <<-HTML
<li><label for="comment_post">Post
    <small></small>
    </label>
<select id="comment_post_id" name="comment[post_id]"><option value=""></option>
<option value="3">Post#3</option>
<option value="4">Post#4</option>
<option value="1">Post#1</option>
<option value="2">Post#2</option></select></li>
    HTML

    assert_equal expected, typus_belongs_to_field('post')

  end

=end

=begin

  # FIXME: Problem with the number of attributes.
  def test_typus_belongs_to_field_with_different_attribute_name

    params = { :controller => 'admin/post', :id => 1, :action => :edit }
    self.stubs(:params).returns(params)

    @current_user = mock()
    @current_user.stubs(:can?).with('create', Comment).returns(true)
    @resource = Post

    expected = <<-HTML
<li><label for="post_favorite_comment">Favorite comment
    <small><a href="http://test.host/admin/comments/new?back_to=%2Fadmin%2Fpost%2Fedit%2F1&selected=favorite_comment_id" onclick="return confirm('Are you sure you want to leave this page?\\n\\nIf you have made any changes to the fields without clicking the Save/Update entry button, your changes will be lost.\\n\\nClick OK to continue, or click Cancel to stay on this page.');">Add</a></small>
    </label>
<select id="post_favorite_comment_id" name="post[favorite_comment_id]"><option value=""></option>
<option value="1">John</option>
<option value="2">Me</option>
<option value="3">John</option>
<option value="4">Me</option></select></li>
    HTML

    assert_equal expected, typus_belongs_to_field('favorite_comment')

  end

=end

=begin

  # FIXME: Problem with the number of params.
  def test_typus_tree_field

    self.stubs(:expand_tree_into_select_field).returns('expand_tree_into_select_field')

    @resource = Page

    expected = <<-HTML
<li><label for="page_parent">Parent</label>
<select id="page_parent"  name="page[parent]">
  <option value=""></option>
  expand_tree_into_select_field
</select></li>
    HTML

    assert_equal expected, typus_tree_field('parent')

  end

=end

  should "verify attribute_disabled" do
    @resource = Post
    assert !attribute_disabled?('test')
    Post.expects(:accessible_attributes).returns(['test'])
    assert !attribute_disabled?('test')
    Post.expects(:accessible_attributes).returns(['no_test'])
    assert attribute_disabled?('test')
  end

=begin

  def test_expand_tree_into_select_field

    items = Page.roots

    # Page#1 is a root.

    @item = Page.find(1)
    output = expand_tree_into_select_field(items, 'parent_id')
    expected = <<-HTML
<option  value="1"> &#8627; Page#1</option>
<option  value="2">&nbsp;&nbsp; &#8627; Page#2</option>
<option  value="3"> &#8627; Page#3</option>
<option  value="4">&nbsp;&nbsp; &#8627; Page#4</option>
<option  value="5">&nbsp;&nbsp; &#8627; Page#5</option>
<option  value="6">&nbsp;&nbsp;&nbsp;&nbsp; &#8627; Page#6</option>
    HTML
    assert_equal expected, output

    # Page#4 is a children.

    @item = Page.find(4)
    output = expand_tree_into_select_field(items, 'parent_id')
    expected = <<-HTML
<option  value="1"> &#8627; Page#1</option>
<option  value="2">&nbsp;&nbsp; &#8627; Page#2</option>
<option selected value="3"> &#8627; Page#3</option>
<option  value="4">&nbsp;&nbsp; &#8627; Page#4</option>
<option  value="5">&nbsp;&nbsp; &#8627; Page#5</option>
<option  value="6">&nbsp;&nbsp;&nbsp;&nbsp; &#8627; Page#6</option>
    HTML
    assert_equal expected, output

  end

=end

end
