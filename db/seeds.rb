# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# supermessi = User.find_or_create_by({username: 'supermessi', email: 'supermessi@welltek.com'})
# supermessi.password = 'da42busay,'
# supermessi.save!

User.delete_all
dev = User.find_or_create_by({username: 'dev', email: 'dev'})
dev.password = 'password'
dev.save!
student = User.find_or_create_by({username: 'student', email: 'student'})
student.password = 'password'
student.save!
teacher = User.find_or_create_by({username: 'teacher', email: 'teacher'})
teacher.password = 'password'
teacher.save!

# workshop_user1 = User.find_or_create_by({username: 'xialiaozhuren1',email: 'xialiaozhuren1'})
# workshop_user1.password = 'password'
# workshop_user1.save!

# workshop_user2 = User.find_or_create_by({username: 'xialiaozhuren2',email: 'xialiaozhuren2'})
# workshop_user2.password = 'password'
# workshop_user2.save!

# workshop_user3 = User.find_or_create_by({username: 'zupinzhuren1',email: 'zupinzhuren1'})
# workshop_user3.password = 'password'
# workshop_user3.save!

# workshop_user4 = User.find_or_create_by({username: 'zupinzhuren2',email: 'zupinzhuren2'})
# workshop_user4.password = 'password'
# workshop_user4.save!

# workteam_user5 = User.find_or_create_by({username: 'xialiaobanzhuren1',email: 'xialiaobanzhuren1'})
# workteam_user5.password = 'password'
# workteam_user5.save!

# workteam_user6 = User.find_or_create_by({username: 'xialiaobanzhuren2',email: 'xialiaobanzhuren2'})
# workteam_user6.password = 'password'
# workteam_user6.save!

# workteam_user7 = User.find_or_create_by({username: 'zupinbanzhuren1',email: 'zupinbanzhuren1'})
# workteam_user7.password = 'password'
# workteam_user7.save!

# workteam_user8 = User.find_or_create_by({username: 'zupinbanzhuren2',email: 'zupinbanzhuren2'})
# workteam_user8.password = 'password'
# workteam_user8.save!

# checking_user1 = User.find_or_create_by({username: 'zhijianyuan1',email: 'zhijianyuan1'})
# checking_user1.password = 'password'
# checking_user1.save!

# production_manager = User.find_or_create_by({username: 'shengchanjingli',email: 'shengchanjingli'})
# production_manager.password = 'password'
# production_manager.save!

AuthRule.delete_all
rule10 = AuthRule.find_or_create_by({ name: 'Admin/index', title: '后台首页'})
rule10.save!


rule20 = AuthRule.find_or_create_by({ name: 'input_class_grade/index', title: '课堂成绩录入'})
rule20.save!
# rule20 = AuthRule.find_or_create_by({ name: 'roduction-manag/index', title: '生产管理'})
# rule20.save!
# rule21 = AuthRule.find_or_create_by({ name: 'production-manage/order-manage', title: '订单'})
# rule21.parent = rule20
# rule21.save!
# rule22 = AuthRule.find_or_create_by({ name: 'production-manage/order-workshop', title: '车间'})
# rule22.parent = rule20
# rule22.save!
# rule23 = AuthRule.find_or_create_by({ name: 'production-manage/order-team', title: '班组'})
# rule23.parent = rule20
# rule23.save!
# rule24 = AuthRule.find_or_create_by({ name: 'production-manage/quality-checking', title: '质检'})
# rule24.parent = rule20
# rule24.save!


rule30 = AuthRule.find_or_create_by({ name: 'student_grade/index', title: '学生成绩查看'})
rule30.save!
# rule30 = AuthRule.find_or_create_by({ name: 'approval/index', title: '审批管理'})
# rule30.save!

# rule40 = AuthRule.find_or_create_by({ name: 'my-approval/index', title: '审批'})
# rule40.save!

rule50 = AuthRule.find_or_create_by({ name: 'system-manage/index', title: '系统管理'})
rule50.save!
rule51 = AuthRule.find_or_create_by({ name: 'system-manage/authority', title: '权限管理'})
rule51.parent = rule50
rule51.save!
rule52 = AuthRule.find_or_create_by({ name: 'system-manage/authority-groups', title: '权限组管理'})
rule52.parent = rule50
rule52.save!
rule53 = AuthRule.find_or_create_by({ name: 'system-manage/user-authority-groups', title: '用户权限分配'})
rule53.parent = rule50
rule53.save!
rule54 = AuthRule.find_or_create_by({ name: 'system-manage/menu-manage', title: '菜单管理'})
rule54.parent = rule50
rule54.save!

# rule60 = AuthRule.find_or_create_by({ name: 'daily-summary/index', title: '日清总结'})
# rule60.save!
# rule61 = AuthRule.find_or_create_by({ name: 'daily-summary/cost', title: '花费科目'})
# rule61.parent = rule60
# rule61.save!
# rule62 = AuthRule.find_or_create_by({ name: 'daily-summary/daily-work', title: '工作日报'})
# rule62.parent = rule60
# rule62.save!

rule60 = AuthRule.find_or_create_by({ name: 'resource-manage/index', title: '教学资源管理'})
rule60.save!
rule61 = AuthRule.find_or_create_by({ name: 'resource-manage/class', title: '班级管理'})
rule61.parent = rule60
rule61.save!
rule62 = AuthRule.find_or_create_by({ name: 'resource-manage/class-student', title: '班级-学生管理'})
rule62.parent = rule60
rule62.save!
rule63 = AuthRule.find_or_create_by({ name: 'resource-manage/course', title: '课程管理'})
rule63.parent = rule60
rule63.save!
rule64 = AuthRule.find_or_create_by({ name: 'resource-manage/evaluation', title: '评价指标管理'})
rule64.parent = rule60
rule64.save!
rule65 = AuthRule.find_or_create_by({ name: 'resource-manage/class-course', title: '班级课程分配'})
rule65.parent = rule60
rule65.save!
rule66 = AuthRule.find_or_create_by({ name: 'resource-manage/course-evaluation', title: '课程评价指标分配'})
rule66.parent = rule60
rule66.save!
rule67 = AuthRule.find_or_create_by({ name: 'resource-manage/teacher-course', title: '教师课程分配'})
rule67.parent = rule60
rule67.save!
rule68 = AuthRule.find_or_create_by({ name: 'resource-manage/teacher-class-course', title: '教师班级课程管理'})
rule68.parent = rule60
rule68.save!

rule70 = AuthRule.find_or_create_by({ name: 'users-manage/index', title: '用户管理'})
rule70.save!
rule71 = AuthRule.find_or_create_by({ name: 'users-manage/teacher', title: '教师信息管理'})
rule71.parent = rule70
rule71.save!
rule72 = AuthRule.find_or_create_by({ name: 'users-manage/student', title: '学生信息管理'})
rule72.parent = rule70
rule72.save!
rule73 = AuthRule.find_or_create_by({ name: 'users-manage/organization', title: '组织管理'})
rule73.parent = rule70
rule73.save!

# rule80 = AuthRule.find_or_create_by({ name: 'employee-information/index', title: '员工信息'})
# rule80.save!
# rule81 = AuthRule.find_or_create_by({ name: 'employee-information/attendance-record', title: '考勤记录'})
# rule81.parent = rule80
# rule81.save!

# rule90 = AuthRule.find_or_create_by({ name: 'vehicle-manage/index', title: '车辆管理'})
# rule90.save!
# rule91 = AuthRule.find_or_create_by({ name: 'vehicle-manage/vehicle-comeandgo-identify', title: '车辆进出识别'})
# rule91.parent = rule90
# rule91.save!

AuthGroup.delete_all
group1 = AuthGroup.find_or_create_by({title: '超级管理员'})
group1.save!
group2 = AuthGroup.find_or_create_by({title: '老师'})
group2.save!
group3 = AuthGroup.find_or_create_by({title: '学生'})
group3.save!
# group2 = AuthGroup.find_or_create_by({title: '总经理'})
# group2.save!
# group3 = AuthGroup.find_or_create_by({title: '生产经理'})
# group3.save!
# group4 = AuthGroup.find_or_create_by({title: '车间主任'})
# group4.save!
# group5 = AuthGroup.find_or_create_by({title: '班组长'})
# group5.save!

group6 = AuthGroup.find_or_create_by({title: '开发者'})
group6.save!
# group7 = AuthGroup.find_or_create_by({title: '质检员'})
# group7.save!

group1.auth_rules.destroy_all
group1.auth_rules.push rule10
group1.auth_rules.push rule20
group1.auth_rules.push rule30
# group1.auth_rules.push rule30
# group1.auth_rules.push rule40
group1.auth_rules.push rule50
group1.auth_rules.push rule51
group1.auth_rules.push rule52
group1.auth_rules.push rule53

group1.auth_rules.push rule60
group1.auth_rules.push rule61
group1.auth_rules.push rule62
group1.auth_rules.push rule63
group1.auth_rules.push rule64
group1.auth_rules.push rule65
group1.auth_rules.push rule66
group1.auth_rules.push rule67
group1.auth_rules.push rule68
# group1.auth_rules.push rule61
group1.auth_rules.push rule70
group1.auth_rules.push rule71
group1.auth_rules.push rule72
group1.auth_rules.push rule73
# group1.auth_rules.push rule74

group2.auth_rules.push rule10
group2.auth_rules.push rule20

group3.auth_rules.push rule10
group3.auth_rules.push rule30
# group2.auth_rules.destroy_all
# group2.auth_rules.push rule10
# group2.auth_rules.push rule20
# group2.auth_rules.push rule21
# group2.auth_rules.push rule80
# group2.auth_rules.push rule81

# group3.auth_rules.destroy_all
# group3.auth_rules.push rule10
# group3.auth_rules.push rule20
# group3.auth_rules.push rule21

# group4.auth_rules.destroy_all
# group4.auth_rules.push rule10
# group4.auth_rules.push rule20
# group4.auth_rules.push rule22

# group5.auth_rules.destroy_all
# group5.auth_rules.push rule10
# group5.auth_rules.push rule20
# group5.auth_rules.push rule23
# group5.auth_rules.push rule24

group6.auth_rules.destroy_all
group6.auth_rules.push rule10
group6.auth_rules.push rule20
# group6.auth_rules.push rule21
# group6.auth_rules.push rule22
# group6.auth_rules.push rule23
# group6.auth_rules.push rule24
group6.auth_rules.push rule30
# group6.auth_rules.push rule40
group6.auth_rules.push rule50
group6.auth_rules.push rule51
group6.auth_rules.push rule52
group6.auth_rules.push rule53
group6.auth_rules.push rule54

group6.auth_rules.push rule60
group6.auth_rules.push rule61
group6.auth_rules.push rule62
group6.auth_rules.push rule63
group6.auth_rules.push rule64
group6.auth_rules.push rule65
group6.auth_rules.push rule66
group6.auth_rules.push rule67
group6.auth_rules.push rule68
group6.auth_rules.push rule70
group6.auth_rules.push rule71
group6.auth_rules.push rule72
group6.auth_rules.push rule73
# group6.auth_rules.push rule74
# group6.auth_rules.push rule80
# group6.auth_rules.push rule81
# group6.auth_rules.push rule90
# group6.auth_rules.push rule91

# group7.auth_rules.destroy_all
# group7.auth_rules.push rule10
# group7.auth_rules.push rule24

# supermessi.auth_groups.destroy_all
# supermessi.auth_groups.push group1

# production_manager.auth_groups.destroy_all
# production_manager.auth_groups.push group3

# workshop_user1.auth_groups.destroy_all
# workshop_user1.auth_groups.push group4
# workshop_user2.auth_groups.destroy_all
# workshop_user2.auth_groups.push group4
# workshop_user3.auth_groups.destroy_all
# workshop_user3.auth_groups.push group4
# workshop_user4.auth_groups.destroy_all
# workshop_user4.auth_groups.push group4

# workteam_user5.auth_groups.destroy_all
# workteam_user5.auth_groups.push group5
# workteam_user6.auth_groups.destroy_all
# workteam_user6.auth_groups.push group5
# workteam_user7.auth_groups.destroy_all
# workteam_user7.auth_groups.push group5
# workteam_user8.auth_groups.destroy_all
# workteam_user8.auth_groups.push group5

# checking_user1.auth_groups.destroy_all
# checking_user1.auth_groups.push group7

dev.auth_groups.destroy_all
dev.auth_groups.push group6

student.auth_groups.destroy_all
student.auth_groups.push group3

teacher.auth_groups.destroy_all
teacher.auth_groups.push group2
# order = Order.find_or_create_by(id: 1)
# order.no = '1271115636988060'
# order.title = 'xxxxxx'
# order.client_title = '中铁19局'
# order.record_time = '2018-05-03'
# order.save!

# work_order = WorkOrder.find_or_create_by(id: 1)
# work_order.number = 6
# work_order.title = '中铁19局京雄铁路'
# work_order.template_type = '实体墩(9*3.6m-7.2*3m)墩身平板 模板焊接单（50:1）'
# work_order.maker = '王新'
# work_order.order_id = 1 
# work_order.status = 1
# work_order.record_time = Time.now
# work_order.save!

# material = Material.find_or_create_by(id: 1)
# material.number = 8
# material.graph_no = '图号DS-936-01,图号DS-936-02,图号DS-936-03,图号DS-936-05'
# material.name = '4.2m*2m平板'
# material.comment = '边框孔冲Φ22*30孔'
# material.work_order_id = 1
# material.save!


# material = Material.find_or_create_by(id: 2)
# material.number = 8
# material.graph_no = '图号DS-936-09,图号DS-936-08,图号DS-936-07,图号DS-936-09'
# material.name = '4.5m*20m平板'
# material.comment = '边框孔冲Φ22*80孔'
# material.work_order_id = 1
# material.save!


# bom1 = Bom.find_or_create_by(id: 1)
# bom1.number = 2
# bom1.total = 16
# bom1.name = '面板'
# bom1.spec = '6mm钢板'
# bom1.length = 1900
# bom1.width = 2000
# bom1.comment = ''
# bom1.material_id = 1
# bom1.save!

# bom2 = Bom.find_or_create_by(id: 2)
# bom2.number = 3
# bom2.total = 24
# bom2.name = '流水槽面板4'
# bom2.spec = '7mm钢板'
# bom2.length = 555
# bom2.width = 333
# bom2.comment = 'aaaaa'
# bom2.material_id = 1
# bom2.save!



# bom3 = Bom.find_or_create_by(id: 3)
# bom3.number = 2
# bom3.total = 16
# bom3.name = '面板1'
# bom3.spec = '6mm钢板1'
# bom3.length = 1800
# bom3.width = 1900
# bom3.comment = ''
# bom3.material_id = 2
# bom3.save!

# bom4 = Bom.find_or_create_by(id: 24)
# bom4.number = 3
# bom4.total = 24
# bom4.name = '流水槽面板2'
# bom4.spec = '7mm钢板2'
# bom4.length = 666
# bom4.width = 777
# bom4.comment = 'aaaaa'
# bom4.material_id = 2
# bom4.save!






# ws1 = WorkShop.find_or_create_by(id: 1)
# ws1.name = '下料车间1'
# ws1.dept_type = '下料'
# ws1.user_id = 3
# ws1.save!

# ws3 = WorkShop.find_or_create_by(id: 2)
# ws3.name = '下料车间2'
# ws3.dept_type = '下料'
# ws3.user_id = 4
# ws3.save!

# ws2 = WorkShop.find_or_create_by(id: 3)
# ws2.name = '组拼车间1'
# ws2.dept_type = '组拼'
# ws2.user_id = 5
# ws2.save!

# ws4 = WorkShop.find_or_create_by(id: 4)
# ws4.name = '组拼车间2'
# ws4.dept_type = '组拼'
# ws4.user_id = 6
# ws4.save!



# wt3 = WorkTeam.find_or_create_by(id: 1)
# wt3.name = '组拼班组1'
# wt3.work_shop_id = 3
# wt3.user_id = 9
# wt3.save!


# wt4 = WorkTeam.find_or_create_by(id: 2)
# wt4.name = '组拼班组2'
# wt4.work_shop_id = 4
# wt4.user_id = 10
# wt4.save!

# wt1 = WorkTeam.find_or_create_by(id: 3)
# wt1.name = '下料班组1'
# wt1.work_shop_id = 1
# wt1.user_id = 7
# wt1.save!


# wt2 = WorkTeam.find_or_create_by(id: 4)
# wt2.name = '下料班组2'
# wt2.work_shop_id = 1
# wt2.user_id = 8
# wt2.save!

# cost1 = Cost.find_or_create_by({title:'车辆费2'})
# cost1.save!
# cost2 = Cost.find_or_create_by({title:'保养费1'})
# cost2.parent=cost1
# cost2.save!
# cost3 = Cost.find_or_create_by({title:'加油费3'})
# cost3.parent=cost1
# cost3.save!
# cost4 = Cost.find_or_create_by({title:'保险费4'})
# cost4.parent=cost3
# cost4.save!

# cost5 = Cost.find_or_create_by({title:'邮电费5'})
# cost5.save!
# cost6 = Cost.find_or_create_by({title:'快递费6'})
# cost6.parent=cost5
# cost6.save!
