require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "username" do
    assert users(:one).username == 'admin_test'
  end
end
