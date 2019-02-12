# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ClassRoom.delete_all
class1 = ClassRoom.find_or_create_by({name: '英语1班',year: '2016',clno: '101'})
class1.save!
class2 = ClassRoom.find_or_create_by({name: '英语2班',year: '2016',clno: '102'})
class2.save!
class3 = ClassRoom.find_or_create_by({name: '英语3班',year: '2016',clno: '103'})
class3.save!
class4 = ClassRoom.find_or_create_by({name: '',year: '',clno: '',status: 0})
class4.save!

Course.delete_all
course1 = Course.find_or_create_by({name: '英语1',cno: '01'})
course1.save!
course2 = Course.find_or_create_by({name: '英语2',cno: '02'})
course2.save!
course3 = Course.find_or_create_by({name: '英语3',cno: '03'})
course3.save!

class1.courses.destroy_all
class1.courses.push course1

class2.courses.destroy_all
class2.courses.push course2

class3.courses.destroy_all
class3.courses.push course3

Evaluation.delete_all
evaluation1 = Evaluation.find_or_create_by({name: '评价指标1',eno: '01',types: 'input',description: 'input some string or number'})
evaluation1.save!
evaluation2 = Evaluation.find_or_create_by({name: '评价指标2',eno: '02',types: 'option',description: 'A@B@C@D'})
evaluation2.save!
evaluation3 = Evaluation.find_or_create_by({name: '评价指标3',eno: '03',types: 'input',description: 'input some string or number'})
evaluation3.save!
evaluation4 = Evaluation.find_or_create_by({name: '评价指标4',eno: '04',types: 'option',description: 'Excellent@Good@Average@Fair@Poor@Fail'})
evaluation4.save!

course1.evaluations.destroy_all
course1.evaluations.push evaluation1
course1.evaluations.push evaluation2

course2.evaluations.destroy_all
course2.evaluations.push evaluation2
course2.evaluations.push evaluation3

course3.evaluations.destroy_all
course3.evaluations.push evaluation1
course3.evaluations.push evaluation3

Student.delete_all
hll = Student.find_or_create_by({name: 'hll', email: 'hll',year: '2016',sno: '2016101001',tel: '15066666666'})
hll.class_room_id = class1.id
hll.save!
cj = Student.find_or_create_by({name: 'cj', email: 'cj',year: '2016',sno: '2016102001',tel: '15066666666'})
cj.class_room_id = class2.id
cj.save!

Teacher.delete_all
yyk = Teacher.find_or_create_by({name: 'yyk', email: 'yyk',year: '2016',tno: '2016001',tel: '15066666666'})
yyk.save!
dev = Teacher.find_or_create_by({name: 'dev', email: 'dev',year: '2016',tno: '2016002',tel: '15066666666'})
dev.save!

yyk.courses.destroy_all
yyk.courses.push course1
yyk.courses.push course2

dev.courses.destroy_all
dev.courses.push course2
dev.courses.push course3

User.delete_all
user1 = User.new
user1.password = 'password'
user1.owner = hll
user1.username = hll.name
user1.email = hll.email
user1.tel = hll.tel
user1.save!
user2 = User.new
user2.password = 'password'
user2.owner = cj
user2.username = cj.name
user2.email = cj.email
user2.tel = cj.tel
user2.save!
user3 = User.new
user3.password = 'password'
user3.owner = yyk
user3.username = yyk.name
user3.email = yyk.email
user3.tel = yyk.tel
user3.save!
user4 = User.new
user4.password = 'password'
user4.owner = dev
user4.username = dev.name
user4.email = dev.email
user4.tel = dev.tel
user4.save!

TeachersClassesCourse.delete_all

tcc1 = TeachersClassesCourse.find_or_create_by({teachers_id:yyk.id,class_rooms_id:class1.id,courses_id:course1.id,term:'2018秋季学期'})
tcc1.save!
tcc2 = TeachersClassesCourse.find_or_create_by({teachers_id:yyk.id,class_rooms_id:class1.id,courses_id:course2.id,term:'2018秋季学期'})
tcc2.save!
tcc3 = TeachersClassesCourse.find_or_create_by({teachers_id:yyk.id,class_rooms_id:class2.id,courses_id:course3.id,term:'2018秋季学期'})
tcc3.save!

tcc4 = TeachersClassesCourse.find_or_create_by({teachers_id:dev.id,class_rooms_id:class2.id,courses_id:course1.id,term:'2018秋季学期'})
tcc4.save!
tcc5 = TeachersClassesCourse.find_or_create_by({teachers_id:dev.id,class_rooms_id:class2.id,courses_id:course2.id,term:'2018秋季学期'})
tcc5.save!
tcc6 = TeachersClassesCourse.find_or_create_by({teachers_id:dev.id,class_rooms_id:class3.id,courses_id:course1.id,term:'2018秋季学期'})
tcc6.save!

tcc7 = TeachersClassesCourse.find_or_create_by({teachers_id:yyk.id,class_rooms_id:class1.id,courses_id:course3.id,term:'2019春季学期'})
tcc7.save!
tcc8 = TeachersClassesCourse.find_or_create_by({teachers_id:yyk.id,class_rooms_id:class1.id,courses_id:course2.id,term:'2019春季学期'})
tcc8.save!
tcc9 = TeachersClassesCourse.find_or_create_by({teachers_id:yyk.id,class_rooms_id:class2.id,courses_id:course1.id,term:'2019春季学期'})
tcc9.save!

tcc10 = TeachersClassesCourse.find_or_create_by({teachers_id:dev.id,class_rooms_id:class2.id,courses_id:course3.id,term:'2019春季学期'})
tcc10.save!
tcc11 = TeachersClassesCourse.find_or_create_by({teachers_id:dev.id,class_rooms_id:class2.id,courses_id:course2.id,term:'2019春季学期'})
tcc11.save!
tcc12 = TeachersClassesCourse.find_or_create_by({teachers_id:dev.id,class_rooms_id:class3.id,courses_id:course3.id,term:'2019春季学期'})
tcc12.save!


AuthRule.delete_all
rule10 = AuthRule.find_or_create_by({ name: 'Admin/index', title: '后台首页'})
rule10.save!


rule20 = AuthRule.find_or_create_by({ name: 'input_class_grade/index', title: '课堂成绩录入'})
rule20.save!


rule30 = AuthRule.find_or_create_by({ name: 'student_grade/index', title: '学生成绩查看'})
rule30.save!

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

AuthGroup.delete_all
group1 = AuthGroup.find_or_create_by({title: '超级管理员'})
group1.save!
group2 = AuthGroup.find_or_create_by({title: '老师'})
group2.save!
group3 = AuthGroup.find_or_create_by({title: '学生'})
group3.save!

group6 = AuthGroup.find_or_create_by({title: '开发者'})
group6.save!

group1.auth_rules.destroy_all
group1.auth_rules.push rule10
group1.auth_rules.push rule20
group1.auth_rules.push rule30

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

group1.auth_rules.push rule70
group1.auth_rules.push rule71
group1.auth_rules.push rule72


group2.auth_rules.push rule10
group2.auth_rules.push rule20

group3.auth_rules.push rule10
group3.auth_rules.push rule30


group6.auth_rules.destroy_all
group6.auth_rules.push rule10
group6.auth_rules.push rule20

group6.auth_rules.push rule30

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

user4.auth_groups.destroy_all
user4.auth_groups.push group6

user1.auth_groups.destroy_all
user1.auth_groups.push group3
user2.auth_groups.destroy_all
user2.auth_groups.push group3

user3.auth_groups.destroy_all
user3.auth_groups.push group2
