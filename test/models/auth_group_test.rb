require 'test_helper'

class AuthGroupTest < ActiveSupport::TestCase
  test "should not save without title" do
    g = AuthGroup.new
    assert_not g.save
  end

  test "should save" do
    g = AuthGroup.new
    g.title = "title1"
    assert g.save
  end

  test "should not save with same title" do
    g = AuthGroup.new
    g.title = "title1"
    g.save!

    g = AuthGroup.new
    g.title = "title1"
    assert_not g.save
  end

  test "should save with different title" do
    g = AuthGroup.new
    g.title = "title1"
    g.save!

    g = AuthGroup.new
    g.title = "title2"
    assert g.save
  end

  test "should auth_groups auth_rules work" do
    assert_empty auth_groups(:one).auth_rules
    
    auth_groups(:one).auth_rules << auth_rules(:one)
    assert_not_empty auth_groups(:one).auth_rules

    r = auth_groups(:one).auth_rules[0]
    assert_same r, auth_rules(:one)
    assert_equal 1, r.auth_groups.count
    assert_equal r.auth_groups[0], auth_groups(:one)

    auth_groups(:one).auth_rules << auth_rules(:two)
    assert_equal 2, auth_groups(:one).auth_rules.count
  end

end
