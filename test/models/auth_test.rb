require 'test_helper'

class AuthTest < ActiveSupport::TestCase
  test "should user auth work when single auth_name" do
    auth_groups(:one).auth_rules << auth_rules(:one)
    auth_groups(:one).auth_rules << auth_rules(:two)

    users(:one).auth_groups << auth_groups(:one)

    auth_name = auth_rules(:one).name
    assert Auth.check(auth_name, users(:one))

    auth_name = auth_rules(:three).name
    assert_not Auth.check(auth_name, users(:one))
  end

  test "should user auth work when single auth_name and status equal zero" do
    auth_rules(:one).status = 0
    auth_groups(:one).auth_rules << auth_rules(:one)

    users(:one).auth_groups << auth_groups(:one)

    auth_name = auth_rules(:one).name
    assert_not Auth.check(auth_name, users(:one))
  end

  test "should user auth work when single auth_name and condition not empty" do
    code="|h|h[:score]>100"
    auth_rules(:one).condition = code
    auth_groups(:one).auth_rules << auth_rules(:one)

    users(:one).auth_groups << auth_groups(:one)

    auth_name = auth_rules(:one).name
    assert Auth.check(auth_name, users(:one))
    assert Auth.check(auth_name, users(:one), outer: {score: 200})
    assert_not Auth.check(auth_name, users(:one), outer: {score: 50})
  end

  test "should user auth work when single auth_name and status equal zero and condition not empty" do
    code="|h|h[:score]>100"
    auth_rules(:one).condition = code
    auth_rules(:one).status = 0
    auth_groups(:one).auth_rules << auth_rules(:one)

    users(:one).auth_groups << auth_groups(:one)

    auth_name = auth_rules(:one).name
    assert_not Auth.check(auth_name, users(:one))
    assert_not Auth.check(auth_name, users(:one), outer: {score: 200})
    assert_not Auth.check(auth_name, users(:one), outer: {score: 50})
  end

  test "should user auth work when multiple auth_name" do
    auth_groups(:one).auth_rules << auth_rules(:one)
    auth_groups(:one).auth_rules << auth_rules(:two)

    users(:one).auth_groups << auth_groups(:one)

    #relation = 'or'
    auth_name = "#{auth_rules(:one).name},#{auth_rules(:two).name}"
    assert Auth.check(auth_name, users(:one))
    auth_name = "#{auth_rules(:one).name},#{auth_rules(:three).name}"
    assert Auth.check(auth_name, users(:one))
    auth_name = "#{auth_rules(:three).name},#{auth_rules(:four).name}"
    assert_not Auth.check(auth_name, users(:one))
    auth_name = "#{auth_rules(:one).name},no_exist_auth_name"
    assert Auth.check(auth_name, users(:one))
    auth_name = "#{auth_rules(:three).name},no_exist_auth_name"
    assert_not Auth.check(auth_name, users(:one))

    #relation = 'and'
    auth_name = "#{auth_rules(:one).name},#{auth_rules(:two).name}"
    assert Auth.check(auth_name, users(:one), relation: 'and')
    auth_name = "#{auth_rules(:one).name},#{auth_rules(:three).name}"
    assert_not Auth.check(auth_name, users(:one), relation: 'and')
    auth_name = "#{auth_rules(:three).name},#{auth_rules(:four).name}"
    assert_not Auth.check(auth_name, users(:one), relation: 'and')
    auth_name = "#{auth_rules(:one).name},no_exist_auth_name"
    assert_not Auth.check(auth_name, users(:one), relation: 'and')
    auth_name = "#{auth_rules(:three).name},no_exist_auth_name"
    assert_not Auth.check(auth_name, users(:one), relation: 'and')
  end

end
