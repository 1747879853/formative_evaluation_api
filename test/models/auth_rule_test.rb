require 'test_helper'

class AuthRuleTest < ActiveSupport::TestCase
  test "should not save without name" do
    r = AuthRule.new
    r.title = "rule1"
    assert_not r.save
  end

  test "should not save without title" do
    r = AuthRule.new
    r.name = "name1"
    assert_not r.save
  end

  test "should save" do
    r = AuthRule.new
    r.name = "name1"
    r.title = "title1"
    assert r.save
  end

  test "should not save with same name" do
    r = AuthRule.new
    r.name = "name1"
    r.title = "title1"
    r.save!

    r = AuthRule.new
    r.name = "name1"
    r.title = "title2"
    assert_not r.save
  end

  test "should not save with same title" do
    r = AuthRule.new
    r.name = "name1"
    r.title = "title1"
    r.save!

    r = AuthRule.new
    r.name = "name2"
    r.title = "title1"
    assert_not r.save
  end

  test "should save with different name and title" do
    r = AuthRule.new
    r.name = "name1"
    r.title = "title1"
    r.save!

    r = AuthRule.new
    r.name = "name2"
    r.title = "title2"
    assert r.save
  end

  test "should auth_rules acts_as_tree work" do
    r1 = auth_rules(:one)
    r2 = auth_rules(:two)
    assert_equal r1, r2.parent
    assert_not_empty r1.children
    assert_equal 1, r1.children.count
    assert_equal r2, r1.children[0]
  end

end
