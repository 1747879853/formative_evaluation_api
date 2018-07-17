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

group1 = AuthGroup.find_or_create_by({title: '超级管理员'})
group1.save!
group2 = AuthGroup.find_or_create_by({title: '生产经理'})
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


order = Order.find_or_create_by(id: 1)
order.no = '1271115636988060'
order.title = 'xxxxxx'
order.client_title = '力五'
order.record_time = '2018-05-03'
order.save!

work_order = WorkOrder.find_or_create_by(id: 1)
work_order.number = 6
work_order.title = '中铁19局京雄铁路'
work_order.template_type = '实体墩(9*3.6m-7.2*3m)墩身平板 模板焊接单（50:1）'
work_order.maker = '王新'
work_order.order_id = 1 
work_order.status = 1
work_order.record_time = Time.now
work_order.save!

material = Material.find_or_create_by(id: 1)
material.number = 8
material.graph_no = '图号DS-936-01,图号DS-936-02,图号DS-936-03,图号DS-936-05'
material.name = '4.2m*2m平板'
material.comment = '边框孔冲Φ22*30孔'
material.work_order_id = 1
material.save!

bom1 = Bom.find_or_create_by(id: 1)
bom1.number = 2
bom1.total = 16
bom1.name = '面板'
bom1.spec = '6mm钢板'
bom1.length = 1900
bom1.width = 2000
bom1.comment = ''
bom1.material_id = 1
bom1.save!

bom2 = Bom.find_or_create_by(id: 2)
bom2.number = 3
bom2.total = 24
bom2.name = '流水槽面板4'
bom2.spec = '7mm钢板'
bom2.length = 555
bom2.width = 333
bom2.comment = 'aaaaa'
bom2.material_id = 1
bom2.save!
