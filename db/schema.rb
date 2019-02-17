# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_17_113759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_groups", force: :cascade do |t|
    t.string "title", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_groups_rules", id: false, force: :cascade do |t|
    t.bigint "auth_group_id", null: false
    t.bigint "auth_rule_id", null: false
  end

  create_table "auth_groups_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "auth_group_id", null: false
  end

  create_table "auth_rules", force: :cascade do |t|
    t.string "name", null: false
    t.string "title", null: false
    t.integer "status", default: 1, null: false
    t.text "condition"
    t.integer "parent_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_auth_rules_on_name"
  end

  create_table "class_rooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "year", null: false
    t.string "clno", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_rooms_courses", id: false, force: :cascade do |t|
    t.bigint "class_room_id", null: false
    t.bigint "course_id", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.string "cno", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses_evaluations", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "evaluation_id", null: false
  end

  create_table "courses_teachers", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "teacher_id", null: false
  end

  create_table "evaluations", force: :cascade do |t|
    t.string "name", null: false
    t.string "types", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", default: ""
    t.integer "parent_id", default: 0
    t.string "eno", default: "", null: false
    t.string "term"
  end

  create_table "grades", force: :cascade do |t|
    t.bigint "students_id"
    t.bigint "evaluations_id"
    t.bigint "courses_id"
    t.string "grade", default: ""
    t.index ["courses_id"], name: "index_grades_on_courses_id"
    t.index ["evaluations_id"], name: "index_grades_on_evaluations_id"
    t.index ["students_id"], name: "index_grades_on_students_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "sno", null: false
    t.string "tel", default: "", null: false
    t.integer "class_room_id", default: 0, null: false
    t.string "status", default: "1", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "year", default: "0", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "tno", null: false
    t.string "tel", default: "", null: false
    t.string "status", default: "1", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "year", default: "0", null: false
  end

  create_table "teachers_classes_courses", force: :cascade do |t|
    t.bigint "teachers_id"
    t.bigint "class_rooms_id"
    t.bigint "courses_id"
    t.string "term", default: "", null: false
    t.index ["class_rooms_id"], name: "index_teachers_classes_courses_on_class_rooms_id"
    t.index ["courses_id"], name: "index_teachers_classes_courses_on_courses_id"
    t.index ["teachers_id"], name: "index_teachers_classes_courses_on_teachers_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "role", default: "user", null: false
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tel", default: "", null: false
    t.string "status", default: "1", null: false
    t.integer "owner_id", default: 0, null: false
    t.string "owner_type", default: "0", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
