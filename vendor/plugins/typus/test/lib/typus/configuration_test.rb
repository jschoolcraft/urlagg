require "test/test_helper"

class ConfigurationTest < ActiveSupport::TestCase

  should "verify typus roles is loaded" do
    assert Typus::Configuration.respond_to?(:roles!)
    assert Typus::Configuration.roles!.kind_of?(Hash)
  end

  should "verify typus config file is loaded" do
    assert Typus::Configuration.respond_to?(:config!)
    assert Typus::Configuration.config!.kind_of?(Hash)
  end

  should "load configuration files from config broken" do
    Typus.expects(:config_folder).at_least_once.returns("../config/broken")
    assert_not_equal Hash.new, Typus::Configuration.roles!
    assert_not_equal Hash.new, Typus::Configuration.config!
  end

  should "load configuration files from config empty" do
    Typus.expects(:config_folder).at_least_once.returns("../config/empty")
    assert_equal Hash.new, Typus::Configuration.roles!
    assert_equal Hash.new, Typus::Configuration.config!
  end

  should "load configuration files from config ordered" do
    Typus.expects(:config_folder).at_least_once.returns("../config/ordered")
    files = Dir[Rails.root.join(Typus.config_folder, "*_roles.yml")]
    expected = files.collect { |file| File.basename(file) }.sort
    assert_equal expected, ["001_roles.yml", "002_roles.yml"]
    expected = { "admin" => { "categories" => "read" } }
    assert_equal expected, Typus::Configuration.roles!
  end

  should "load configuration files from config unordered" do
    Typus.expects(:config_folder).at_least_once.returns("../config/unordered")
    files = Dir[Rails.root.join(Typus.config_folder, "*_roles.yml")]
    expected = files.collect { |file| File.basename(file) }
    assert_equal expected, ["app_one_roles.yml", "app_two_roles.yml"]
    expected = { "admin" => { "categories" => "read, update" } }
    assert_equal expected, Typus::Configuration.roles!
  end

  should "load configuration files from config default" do
    Typus.expects(:config_folder).at_least_once.returns("../config/default")
    assert_not_equal Hash.new, Typus::Configuration.roles!
    assert_not_equal Hash.new, Typus::Configuration.config!
    assert Typus.resources.empty?
  end

end
