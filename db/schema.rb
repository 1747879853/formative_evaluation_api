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

ActiveRecord::Schema.define(version: 2018_07_21_080021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval20180718152612s", force: :cascade do |t|
    t.string "field0"
    t.text "field1"
    t.string "field2"
    t.string "field3"
    t.datetime "field4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_detail20180718152612s", force: :cascade do |t|
    t.string "field0"
    t.string "field1"
    t.integer "approval20180718152612_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_detail_fields", force: :cascade do |t|
    t.bigint "approval_id"
    t.string "name"
    t.string "en_name"
    t.string "control"
    t.string "comment"
    t.string "info"
    t.integer "sequence"
    t.string "selectoptions"
    t.string "dateformat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_approval_detail_fields_on_approval_id"
  end

  create_table "approval_fields", force: :cascade do |t|
    t.bigint "approval_id"
    t.string "name"
    t.string "en_name"
    t.string "control"
    t.string "comment"
    t.string "info"
    t.integer "sequence"
    t.string "selectoptions"
    t.string "dateformat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_approval_fields_on_approval_id"
  end

  create_table "approvals", force: :cascade do |t|
    t.string "name"
    t.string "en_name_main"
    t.string "en_name_detail"
    t.string "comment"
    t.datetime "created_time"
    t.datetime "stoped_time"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "boms", force: :cascade do |t|
    t.integer "number"
    t.integer "total"
    t.string "name"
    t.string "spec"
    t.decimal "length"
    t.decimal "width"
    t.string "comment"
    t.bigint "material_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_boms_on_material_id"
  end

  create_table "boms_approval_details", force: :cascade do |t|
    t.bigint "boms_approval_id"
    t.bigint "bom_id"
    t.integer "approval_number"
    t.integer "real_number"
    t.index ["bom_id"], name: "index_boms_approval_details_on_bom_id"
    t.index ["boms_approval_id"], name: "index_boms_approval_details_on_boms_approval_id"
  end

  create_table "boms_approvals", force: :cascade do |t|
    t.bigint "work_team_task_id"
    t.bigint "user_id"
    t.datetime "record_time"
    t.bigint "approval_owner_id"
    t.datetime "approval_time"
    t.string "approval_comment"
    t.integer "status"
    t.string "apply_comment"
    t.index ["approval_owner_id"], name: "index_boms_approvals_on_approval_owner_id"
    t.index ["user_id"], name: "index_boms_approvals_on_user_id"
    t.index ["work_team_task_id"], name: "index_boms_approvals_on_work_team_task_id"
  end

  create_table "materials", force: :cascade do |t|
    t.integer "number"
    t.string "graph_no"
    t.string "name"
    t.string "comment"
    t.bigint "work_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_order_id"], name: "index_materials_on_work_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "no"
    t.string "title"
    t.string "client_title"
    t.datetime "record_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "procedure_nodes", force: :cascade do |t|
    t.bigint "procedure_id"
    t.string "name"
    t.integer "sequence"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_procedure_nodes_on_owner_type_and_owner_id"
    t.index ["procedure_id"], name: "index_procedure_nodes_on_procedure_id"
  end

  create_table "procedures", force: :cascade do |t|
    t.bigint "approval_id"
    t.string "comment"
    t.datetime "created_time"
    t.datetime "stoped_time"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_procedures_on_approval_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "role", default: "user", null: false
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "work_logs", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "record_time"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_work_logs_on_owner_type_and_owner_id"
  end

  create_table "work_orders", force: :cascade do |t|
    t.integer "number"
    t.string "title"
    t.string "template_type"
    t.string "maker"
    t.bigint "order_id"
    t.integer "status"
    t.datetime "record_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_work_orders_on_order_id"
  end

  create_table "work_shop_tasks", force: :cascade do |t|
    t.bigint "work_shop_id"
    t.bigint "work_order_id"
    t.bigint "user_id"
    t.datetime "record_time"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_shop_tasks_on_user_id"
    t.index ["work_order_id"], name: "index_work_shop_tasks_on_work_order_id"
    t.index ["work_shop_id"], name: "index_work_shop_tasks_on_work_shop_id"
  end

  create_table "work_shops", force: :cascade do |t|
    t.string "name"
    t.string "dept_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_shops_on_user_id"
  end

  create_table "work_team_task_details", force: :cascade do |t|
    t.bigint "work_team_task_id"
    t.bigint "user_id"
    t.datetime "record_time"
    t.integer "finished_number"
    t.integer "passed_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_team_task_details_on_user_id"
    t.index ["work_team_task_id"], name: "index_work_team_task_details_on_work_team_task_id"
  end

  create_table "work_team_tasks", force: :cascade do |t|
    t.bigint "work_team_id"
    t.bigint "material_id"
    t.bigint "user_id"
    t.datetime "record_time"
    t.integer "status"
    t.integer "number"
    t.integer "finished_number"
    t.integer "passed_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_work_team_tasks_on_material_id"
    t.index ["user_id"], name: "index_work_team_tasks_on_user_id"
    t.index ["work_team_id"], name: "index_work_team_tasks_on_work_team_id"
  end

  create_table "work_teams", force: :cascade do |t|
    t.string "name"
    t.bigint "work_shop_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_teams_on_user_id"
    t.index ["work_shop_id"], name: "index_work_teams_on_work_shop_id"
  end

end
