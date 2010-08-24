require "test/test_helper"

class HashTest < ActiveSupport::TestCase

  should "verify Hash#compact" do
    hash = { "a" => "", "b" => nil, "c" => "hello" }
    hash_compacted = { "c" => "hello" }
    assert_equal hash_compacted, hash.compact
  end

end
