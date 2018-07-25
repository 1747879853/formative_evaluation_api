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


workshop_user1 = User.find_or_create_by({username: 'xialiaozhuren1',email: '56700663@qq.com'})
workshop_user1.password = 'password'
workshop_user1.save!

workshop_user2 = User.find_or_create_by({username: 'xialiaozhuren2',email: '56700666@qq.com'})
workshop_user2.password = 'password'
workshop_user2.save!

workshop_user3 = User.find_or_create_by({username: 'zupinzhuren1',email: '56700661@qq.com'})
workshop_user3.password = 'password'
workshop_user3.save!

workshop_user4 = User.find_or_create_by({username: 'zupinzhuren2',email: '56700662@qq.com'})
workshop_user4.password = 'password'
workshop_user4.save!

workteam_user5 = User.find_or_create_by({username: 'xialiaobanzhuren1',email: '56700665@qq.com'})
workteam_user5.password = 'password'
workteam_user5.save!

workteam_user6 = User.find_or_create_by({username: 'xialiaobanzhuren2',email: '56700667@qq.com'})
workteam_user6.password = 'password'
workteam_user6.save!

workteam_user7 = User.find_or_create_by({username: 'zupinbanzhuren1',email: '567006658@qq.com'})
workteam_user7.password = 'password'
workteam_user7.save!

workteam_user8 = User.find_or_create_by({username: 'zupinbanzhuren2',email: '567006678@qq.com'})
workteam_user8.password = 'password'
workteam_user8.save!

cost1 = Cost.find_or_create_by({title:'车辆费1'})
cost1.save!
cost2 = Cost.find_or_create_by({title:'保养费2'})
cost2.parent=cost1
cost2.save!
cost3 = Cost.find_or_create_by({title:'加油费3'})
cost3.parent=cost1
cost3.save!
cost4 = Cost.find_or_create_by({title:'保险费4'})
cost4.parent=cost3
cost4.save!

cost5 = Cost.find_or_create_by({title:'邮电费5'})
cost5.save!
cost6 = Cost.find_or_create_by({title:'快递费6'})
cost6.parent=cost5
cost6.save!




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


material = Material.find_or_create_by(id: 2)
material.number = 8
material.graph_no = '图号DS-936-09,图号DS-936-08,图号DS-936-07,图号DS-936-09'
material.name = '4.5m*20m平板'
material.comment = '边框孔冲Φ22*80孔'
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



bom3 = Bom.find_or_create_by(id: 3)
bom3.number = 2
bom3.total = 16
bom3.name = '面板1'
bom3.spec = '6mm钢板1'
bom3.length = 1800
bom3.width = 1900
bom3.comment = ''
bom3.material_id = 2
bom3.save!

bom4 = Bom.find_or_create_by(id: 24)
bom4.number = 3
bom4.total = 24
bom4.name = '流水槽面板2'
bom4.spec = '7mm钢板2'
bom4.length = 666
bom4.width = 777
bom4.comment = 'aaaaa'
bom4.material_id = 2
bom4.save!






ws1 = WorkShop.find_or_create_by(id: 1)
ws1.name = '下料车间1'
ws1.dept_type = '下料'
ws1.user_id = 3
ws1.save!

ws3 = WorkShop.find_or_create_by(id: 2)
ws3.name = '下料车间2'
ws3.dept_type = '下料'
ws3.user_id = 4
ws3.save!

ws2 = WorkShop.find_or_create_by(id: 3)
ws2.name = '组拼车间1'
ws2.dept_type = '组拼'
ws2.user_id = 5
ws2.save!

ws4 = WorkShop.find_or_create_by(id: 4)
ws4.name = '组拼车间2'
ws4.dept_type = '组拼'
ws4.user_id = 6
ws4.save!



wt1 = WorkTeam.find_or_create_by(id: 1)
wt1.name = '下料班组1'
wt1.work_shop_id = 1
wt1.user_id = 7
wt1.save!


wt2 = WorkTeam.find_or_create_by(id: 2)
wt2.name = '下料班组2'
wt2.work_shop_id = 1
wt2.user_id = 8
wt2.save!

wt3 = WorkTeam.find_or_create_by(id: 1)
wt3.name = '组拼班组1'
wt3.work_shop_id = 3
wt3.user_id = 9
wt3.save!


wt4 = WorkTeam.find_or_create_by(id: 2)
wt4.name = '组拼班组2'
wt4.work_shop_id = 4
wt4.user_id = 10
wt4.save!