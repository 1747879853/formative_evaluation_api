require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save without username" do
    u = User.new
    u.email = "test@test.com"
    assert_not u.save, "saved user without username"
  end

  test "should not save without email" do
    u = User.new
    u.username = "test"
    assert_not u.save, "saved user without email"
  end

  test "should not save without password" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    assert_not u.save, "saved user without password"
  end

  test "should not save when password length<6" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    u.password = "1234"
    assert_not u.save, "saved user with password length<6"
  end

  test "should not save when password length>72" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    u.password = "*"*73
    assert_not u.save, "saved user with password length>72"
  end

  test "should save" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    u.password = "123456"
    assert u.save, "not saved user with username, email, 6-72 password"
  end

  test "should not save with same username" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    u.password = "123456"
    u.save!

    u = User.new
    u.username = "test"
    u.email = "test2@test.com"
    u.password = "123456"

    assert_not u.save, "saved user with same username"
  end

  test "should not save with same email" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    u.password = "123456"
    u.save!

    u = User.new
    u.username = "test2"
    u.email = "test@test.com"
    u.password = "123456"
    assert_not u.save, "saved user with same email"
  end

  test "should save with different username and email" do
    u = User.new
    u.username = "test"
    u.email = "test@test.com"
    u.password = "123456"
    u.save!

    u = User.new
    u.username = "test2"
    u.email = "test2@test.com"
    u.password = "123456"
    assert u.save, "not saved user with different username and email"
  end

  test "should user auth_groups work" do
    assert_empty users(:one).auth_groups
    
    users(:one).auth_groups << auth_groups(:one)
    assert_not_empty users(:one).auth_groups

    g = users(:one).auth_groups[0]
    assert_same g, auth_groups(:one)
    assert_equal 1, g.users.count
    assert_equal g.users[0], users(:one)

    users(:one).auth_groups << auth_groups(:two)
    assert_equal 2, users(:one).auth_groups.count
  end

  test "should user auth_rules work" do
    assert_empty users(:one).auth_rules
    
    auth_groups(:one).auth_rules << auth_rules(:one)
    auth_groups(:one).auth_rules << auth_rules(:two)

    users(:one).auth_groups << auth_groups(:one)

    assert_not_empty users(:one).auth_rules
    assert_equal 2, users(:one).auth_rules.count
    assert_equal users(:one), users(:one).auth_rules[0].users[0]
    assert_equal users(:one), users(:one).auth_rules[1].users[0]
  end

end
