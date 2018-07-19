# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
supermessi = User.find_or_create_by({username: 'supermessi', email: 'supermessi@welltek.com'})
supermessi.password = 'da42busay,'
supermessi.save!

jkropp = User.find_or_create_by({username: 'jkropp', email: 'james@kropp.com'})
jkropp.password = 'password'
jkropp.save!

rules1 = AuthRule.find_or_create_by({ name: 'Admin/Index/index', title: '后台首页'})
rules1.save!
rules2 = AuthRule.find_or_create_by({ name: 'Admin/Index/welcome', title: '欢迎页面' })
rules2.parent = rules1
rules2.save!

rules3 = AuthRule.find_or_create_by({ name: 'Manufacturing/Index/index', title: '生产首页'})
rules3.save!
rules4 = AuthRule.find_or_create_by({ name: 'Manufacturing/Index/bom', title: '物料清单'})
rules4.parent = rules3
rules4.save!

rules5 = AuthRule.find_or_create_by({ name: 'Admin/ShowNav/config', title: '系统设置'})
rules5.save!
rules6 = AuthRule.find_or_create_by({ name: 'Admin/ShowNav/Nav', title: '菜单管理'})
rules6.parent = rules5
rules6.save!

group1 = AuthGroup.find_or_create_by({name: '超级管理员'})
group1.save!
group2 = AuthGroup.find_or_create_by({name: '生产经理'})
group2.save!

group1.auth_rules.destroy_all
group1.auth_rules.push rules1
group1.auth_rules.push rules2

group2.auth_rules.destroy_all
group2.auth_rules.push rules3
group2.auth_rules.push rules4

supermessi.auth_groups.destroy_all
supermessi.auth_groups.push group1

jkropp.auth_groups.destroy_all
jkropp.auth_groups.push group2
