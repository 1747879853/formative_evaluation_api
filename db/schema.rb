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

ActiveRecord::Schema.define(version: 2018_08_08_223945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval20180721064310s", force: :cascade do |t|
    t.string "field0"
    t.text "field1"
    t.string "field2"
    t.string "field3"
    t.datetime "field4"
    t.integer "approval_id"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.integer "procedure_id"
    t.string "node_ids"
    t.string "role_ids"
    t.integer "node_id_now"
    t.integer "submit_to_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180721065907s", force: :cascade do |t|
    t.string "field0"
    t.text "field1"
    t.string "field2"
    t.string "field3"
    t.datetime "field4"
    t.integer "approval_id"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.integer "procedure_id"
    t.string "node_ids"
    t.string "role_ids"
    t.integer "node_id_now"
    t.integer "submit_to_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180722094026s", force: :cascade do |t|
    t.string "field0"
    t.string "field1"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180722193219s", force: :cascade do |t|
    t.datetime "field0"
    t.text "field1"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180722194320s", force: :cascade do |t|
    t.text "field0"
    t.datetime "field1"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180722195439s", force: :cascade do |t|
    t.text "field0"
    t.datetime "field1"
    t.datetime "field2"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180724061652s", force: :cascade do |t|
    t.string "field0"
    t.string "field1"
    t.string "field2"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180724111207s", force: :cascade do |t|
    t.string "field0"
    t.string "field1"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180725212605s", force: :cascade do |t|
    t.datetime "field0"
    t.text "field1"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180725213120s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180725214001s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180725214401s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180725214624s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180726094921s", force: :cascade do |t|
    t.string "field0"
    t.datetime "field1"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180726100021s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180726112047s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval20180726122657s", force: :cascade do |t|
    t.string "field0"
    t.integer "approval_id"
    t.string "approval_name"
    t.integer "user_id"
    t.string "no"
    t.datetime "submit_time"
    t.datetime "finish_time"
    t.integer "procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_admins", force: :cascade do |t|
    t.string "name"
    t.string "comment"
    t.datetime "created_time"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_current_nodes", force: :cascade do |t|
    t.string "node_ids"
    t.bigint "procedure_node_id"
    t.bigint "user_id"
    t.integer "status"
    t.string "owner_type"
    t.bigint "owner_id"
    t.integer "submit_user_id"
    t.index ["owner_type", "owner_id"], name: "index_approval_current_nodes_on_owner_type_and_owner_id"
    t.index ["procedure_node_id"], name: "index_approval_current_nodes_on_procedure_node_id"
    t.index ["user_id"], name: "index_approval_current_nodes_on_user_id"
  end

  create_table "approval_detail20180721064310s", force: :cascade do |t|
    t.string "field0"
    t.string "field1"
    t.integer "approval20180721064310_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_detail20180721065907s", force: :cascade do |t|
    t.string "field0"
    t.string "field1"
    t.integer "approval20180721065907_id"
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

  create_table "approval_details", force: :cascade do |t|
    t.bigint "procedure_node_id"
    t.bigint "user_id"
    t.string "action_str"
    t.string "comment"
    t.datetime "action_time"
    t.string "owner_type"
    t.bigint "owner_id"
    t.index ["owner_type", "owner_id"], name: "index_approval_details_on_owner_type_and_owner_id"
    t.index ["procedure_node_id"], name: "index_approval_details_on_procedure_node_id"
    t.index ["user_id"], name: "index_approval_details_on_user_id"
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
    t.bigint "approval_admin_id"
    t.index ["approval_admin_id"], name: "index_approvals_on_approval_admin_id"
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

  create_table "costdata", force: :cascade do |t|
    t.string "name", null: false
    t.text "thing"
    t.string "money", null: false
    t.string "summaries_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "costs", force: :cascade do |t|
    t.string "title", null: false
    t.integer "parent_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_costs_on_title"
  end

  create_table "employees", force: :cascade do |t|
    t.string "workno"
    t.string "card_id"
    t.string "name"
    t.integer "id_type"
    t.string "id_card"
    t.boolean "no_sign"
    t.string "depart_id"
    t.string "job_id"
    t.string "rule_id"
    t.string "edu_id"
    t.string "native_id"
    t.string "nation_id"
    t.string "status_id"
    t.integer "card_kind"
    t.boolean "put_up"
    t.string "bed_id"
    t.string "group_id"
    t.datetime "birth"
    t.string "gender"
    t.string "marriage"
    t.string "email"
    t.string "phone_code"
    t.string "address"
    t.string "post_code"
    t.string "link_man"
    t.datetime "hire_date"
    t.datetime "contract_date"
    t.datetime "contract_over_date"
    t.datetime "leave_date"
    t.string "dismission_type_id"
    t.string "leave_course"
    t.decimal "pre_balance", precision: 20
    t.integer "pre_sequ"
    t.boolean "icid"
    t.integer "rest_kind"
    t.string "rest_days"
    t.integer "worktime_kind"
    t.string "shifts"
    t.string "shift_id"
    t.decimal "work_hrs", precision: 20
    t.string "remark"
    t.boolean "zlgput_up"
    t.integer "access_level"
    t.string "access_pwd"
    t.string "contact_phone"
    t.boolean "bless"
    t.string "foodtype"
    t.string "graduate_college"
    t.string "specially"
    t.string "introducer"
    t.datetime "redeploy_date"
    t.datetime "redeploy_date2"
    t.decimal "work_age", precision: 20
    t.string "work_status"
    t.datetime "social_insurance_date"
    t.decimal "social_insurance_money", precision: 20
    t.boolean "auto_shift"
    t.integer "inwork_age"
    t.integer "age"
    t.datetime "stop_social_insurance_date"
    t.datetime "stop_job_date"
    t.datetime "long_holiday_date"
    t.string "contact_labour"
    t.datetime "be_regular_date"
    t.string "dorm_building"
    t.string "salary_account"
    t.string "password"
    t.string "password_digest"
    t.string "bank_no"
    t.boolean "is_black"
    t.boolean "is_white"
    t.datetime "balance_time"
    t.decimal "day_consume", precision: 20
    t.decimal "day_max_money", precision: 20
    t.decimal "day_time", precision: 20
    t.decimal "time_max_money", precision: 20
    t.float "day_total_money"
    t.integer "day_total_time"
    t.boolean "is_over_time"
    t.boolean "access_holiday"
    t.boolean "left_holiday"
    t.datetime "left_limit_date"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "photo"
  end

  create_table "local_depart_records", force: :cascade do |t|
    t.string "depart_id"
    t.string "inside_id"
    t.string "group_id"
    t.string "depart_name"
    t.string "principal"
    t.string "emp_prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "local_time_records", force: :cascade do |t|
    t.integer "clock_id"
    t.string "workno"
    t.string "card_id"
    t.datetime "sign_time"
    t.integer "mark"
    t.integer "flag"
    t.string "bill_id"
    t.string "eventname"
    t.integer "position"
    t.datetime "collecttime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "ruihong_cars", force: :cascade do |t|
    t.string "cname"
    t.integer "p_key"
    t.string "carno"
    t.datetime "in_time"
    t.datetime "out_time"
    t.string "i_picno"
    t.string "o_picno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summaries", force: :cascade do |t|
    t.date "date", null: false
    t.string "address"
    t.text "workcontent"
    t.string "transport"
    t.text "explain"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "work_logs", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "record_time"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "work_order_id"
    t.integer "order_id"
    t.integer "user_id"
    t.decimal "passed_number", precision: 3, scale: 2
    t.decimal "number", precision: 3, scale: 2
    t.integer "get_user_id"
    t.integer "parent_id"
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
    t.string "status", default: "1", null: false
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
    t.bigint "work_shop_task_id"
    t.integer "production_status", default: 0
    t.string "current_position"
    t.string "process"
    t.string "finished_process"
    t.integer "paint", default: 0
    t.integer "paint_team"
    t.index ["material_id"], name: "index_work_team_tasks_on_material_id"
    t.index ["user_id"], name: "index_work_team_tasks_on_user_id"
    t.index ["work_shop_task_id"], name: "index_work_team_tasks_on_work_shop_task_id"
    t.index ["work_team_id"], name: "index_work_team_tasks_on_work_team_id"
  end

  create_table "work_teams", force: :cascade do |t|
    t.string "name"
    t.bigint "work_shop_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "1", null: false
    t.index ["user_id"], name: "index_work_teams_on_user_id"
    t.index ["work_shop_id"], name: "index_work_teams_on_work_shop_id"
  end

  add_foreign_key "approvals", "approval_admins"
end
