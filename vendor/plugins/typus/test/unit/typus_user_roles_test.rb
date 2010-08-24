require "test/test_helper"

class TypusUserRolesTest < ActiveSupport::TestCase

  should "get a list of roles" do
    roles = %w( admin designer editor )
    assert_equal roles, Typus::Configuration.roles.map(&:first).sort
  end

  context "A TypusUser with role admin" do

    setup do
      @typus_user = Factory(:typus_user)
      @models = %w( Asset Category Comment Git Page Post Status TypusUser View WatchDog )
    end

    should "verify models access" do
      assert_equal @models, @typus_user.resources.map(&:first).sort
    end

    should "verify resources without actions related are removed" do
      assert !@typus_user.resources.map(&:first).include?('Order')
    end

    should "have access to all actions on models" do
      models = %w( Asset Category Comment Page Post TypusUser View )
      %w( create read update destroy ).each { |a| models.each { |m| assert @typus_user.can?(a, m) } }
    end

    should "verify we can perform action on resource" do
      assert @typus_user.can?('index', 'Status', { :special => true })
    end

    should "verify we cannot perform action on resource" do
      assert @typus_user.cannot?('show', 'Status', { :special => true })
    end

    should "verify we cannot perform actions on resources which don't have that action defined" do
      assert @typus_user.cannot?('index', 'Order')
    end

  end

  context "A TypusUser with role editor" do

    setup do
      @typus_user = Factory(:typus_user, :role => "editor")
    end

    should "verify models access" do
      models = %w( Category Comment Git Post TypusUser View )
      assert_equal models, @typus_user.resources.map(&:first).sort
    end

    should "only create, read and update categories" do
      %w( create read update ).each { |a| assert @typus_user.can?(a, 'Category') }
      %w( delete ).each { |a| assert @typus_user.cannot?(a, 'Category') }
    end

    should "only create, read and update posts" do
      %w( create read update ).each { |a| assert @typus_user.can?(a, 'Post') }
      %w( delete ).each { |a| assert @typus_user.cannot?(a, 'Post') }
    end

    should "only read, update and delete comments" do
      %w( read update delete ).each { |a| assert @typus_user.can?(a, 'Comment') }
      %w( create ).each { |a| assert @typus_user.cannot?(a, 'Comment') }
    end

    should "only read and update typus_users" do
      %w( read update ).each { |a| assert @typus_user.can?(a, 'TypusUser') }
      %w( create delete ).each { |a| assert @typus_user.cannot?(a, 'TypusUser') }
    end

  end

  context "A TypusUser with role designer" do

    setup do
      @typus_user = Factory(:typus_user, :role => "designer")
    end

    should "verify models access" do
      models = %w( Category Comment Post )
      assert_equal models, @typus_user.resources.map(&:first).sort
    end

    should "only read and update categories" do
      %w( read update ).each { |a| assert @typus_user.can?(a, 'Category') }
      %w( create delete ).each { |a| assert @typus_user.cannot?(a, 'Category') }
    end

    should "only read comments" do
      %w( read ).each { |a| assert @typus_user.can?(a, 'Comment') }
      %w( create update delete ).each { |a| assert @typus_user.cannot?(a, 'Comment') }
    end

    should "only read and update posts" do
      %w( read update ).each { |a| assert @typus_user.can?(a, 'Post') }
      %w( create delete ).each { |a| assert @typus_user.cannot?(a, 'Post') }
    end

  end

end
