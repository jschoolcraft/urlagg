require "test/test_helper"

class StringTest < ActiveSupport::TestCase

  should "extract_settings" do
    assert_equal %w( a b c ), "a, b, c".extract_settings
    assert_equal %w( a b c ), " a  , b,  c ".extract_settings
  end

  should "remove prefix" do
    assert_equal "posts", "admin/posts".remove_prefix
    assert_equal "typus_users", "admin/typus_users".remove_prefix
    assert_equal "delayed/jobs", "admin/delayed/jobs".remove_prefix
  end

  should "remove prefix with params" do
    assert_equal "posts", "typus/posts".remove_prefix("typus/")
    assert_equal "typus_users", "typus/typus_users".remove_prefix("typus/")
    assert_equal "delayed/tasks", "typus/delayed/tasks".remove_prefix("typus/")
  end

  should "extract_resource" do
    assert_equal "posts", "admin/posts".extract_resource
    assert_equal "typus_users", "admin/typus_users".extract_resource
    assert_equal "delayed/tasks", "admin/delayed/tasks".extract_resource
  end

  should "extract_class" do
    assert_equal Post, "admin/posts".extract_class
    assert_equal TypusUser, "admin/typus_users".extract_class
    assert_equal Delayed::Task, "admin/delayed/tasks".extract_class
  end

  should "extract_human_name" do
    assert_equal "Post", "admin/posts".extract_human_name
    assert_equal "Typus user", "admin/typus_users".extract_human_name
    assert_equal "Task", "admin/delayed/tasks".extract_human_name
  end

  should "verify String#typus_actions_on" do
    assert_equal %w(cleanup), "Post".typus_actions_on("index")
    assert_equal %w(cleanup), "Post".typus_actions_on(:index)
    assert_equal %w(send_as_newsletter preview), "Post".typus_actions_on(:edit)
    assert "TypusUser".typus_actions_on(:unexisting).empty?
    assert "Post".typus_actions_on(:index).kind_of?(Array)
  end

end
