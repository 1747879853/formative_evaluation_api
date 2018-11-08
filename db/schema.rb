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

ActiveRecord::Schema.define(version: 2018_11_08_080727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "cancan"
    t.text "text"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "act", limit: 255
    t.datetime "act_time"
    t.text "act_thing"
    t.string "ip", limit: 255
  end

  create_table "alarm_ips", primary_key: "ip", id: :string, limit: 50, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "owner_id", null: false
    t.string "owner_type", limit: 50, null: false
    t.integer "as_team", default: 0, null: false
  end

  create_table "alarm_ips_loginouts", primary_key: ["ip", "login_time"], force: :cascade do |t|
    t.serial "id", null: false
    t.string "ip", limit: 50, null: false
    t.integer "owner_id"
    t.string "owner_type", limit: 50
    t.datetime "login_time", null: false
    t.datetime "logout_time"
  end

  create_table "alarm_onloads", id: :serial, force: :cascade do |t|
    t.string "load_name", limit: 50
    t.string "load_ip", limit: 50
    t.datetime "load_time"
    t.integer "load_amount"
  end

  create_table "alarm_phones", primary_key: ["phone", "owner_id", "owner_type"], force: :cascade do |t|
    t.serial "id", null: false
    t.string "phone", limit: 11, null: false
    t.integer "owner_id", null: false
    t.string "owner_type", limit: 50, null: false
  end

  create_table "alarm_reasons", primary_key: ["reason", "lx"], force: :cascade do |t|
    t.serial "id", null: false
    t.string "reason", limit: 50, null: false
    t.integer "lx", null: false
  end

  create_table "alarm_results", id: :serial, force: :cascade do |t|
    t.string "reason", limit: 50
    t.string "result", limit: 50
    t.integer "lx"
  end

  create_table "alarm_types", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  create_table "alarms", primary_key: ["well_id", "record_time", "alarm_type_id"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.integer "alarm_type_id", default: 0, null: false
    t.string "alarm_details", limit: 100
    t.datetime "write_time", null: false
    t.datetime "team_time"
    t.string "team_measure", limit: 100
    t.string "team_duty1", limit: 40
    t.integer "team_status1", limit: 2, default: 0, null: false
    t.datetime "minery_time1"
    t.string "minery_verify1", limit: 100
    t.string "minery_duty1", limit: 40
    t.integer "minery_status1", limit: 2, default: 0, null: false
    t.string "alarm_reason", limit: 200
    t.string "team_result", limit: 200
    t.string "team_duty2", limit: 40
    t.string "team_status2", limit: 2, default: "0", null: false
    t.datetime "minery_time2"
    t.string "minery_verify2", limit: 100
    t.string "minery_duty2", limit: 40
    t.integer "minery_status2", limit: 2, default: 0, null: false
    t.index ["record_time"], name: "idx_alarm_record_time"
    t.index ["well_id", "record_time"], name: "idx_alarms_well_id_record_time", order: { record_time: "DESC NULLS LAST" }
    t.index ["write_time"], name: "idx_alarm_write_time"
  end

  create_table "assessments", id: :serial, force: :cascade do |t|
    t.string "well_id", limit: 16
    t.string "ny", limit: 6
    t.decimal "scts", precision: 5, scale: 2, default: "0.0"
    t.integer "wgraph_count"
    t.decimal "pump_drive", precision: 3, default: "0"
    t.decimal "well_distance", precision: 5, scale: 2, default: "0.0"
    t.decimal "well_times", precision: 4, scale: 1, default: "0.0"
    t.decimal "month_product_oil", precision: 5, default: "0"
    t.decimal "month_has_water", precision: 6, default: "0"
    t.decimal "pump_effe", precision: 5, scale: 2, default: "0.0"
    t.decimal "pump_hang", precision: 7, scale: 2, default: "0.0"
    t.decimal "dynamic_liquid_surface", precision: 7, scale: 2, default: "0.0"
    t.decimal "crude_oil_density", precision: 6, scale: 4, default: "0.0"
    t.decimal "crude_oil_viscosity", precision: 10, scale: 3, default: "0.0"
    t.decimal "avg_effe_distance", precision: 8, scale: 2, default: "0.0"
    t.decimal "avg_max_load", precision: 8, scale: 1, default: "0.0"
    t.decimal "avg_min_load", precision: 8, scale: 1, default: "0.0"
    t.decimal "avg_wgraph_area", precision: 8, scale: 1, default: "0.0"
    t.decimal "avg_daily_liquid", precision: 8, scale: 2, default: "0.0"
  end

  create_table "audit_calculate_wells", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.index ["well_id"], name: "idx_audit_calculate_wells_well_id"
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

  create_table "basket_positions", primary_key: ["basket_id", "record_time"], force: :cascade do |t|
    t.string "basket_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "positions", null: false
    t.datetime "write_time"
    t.index ["basket_id", "record_time"], name: "basket_positions_index"
  end

  create_table "big_pot_base_lasts", primary_key: "pot_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_height", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_upper", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_floor", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "sewage_density", precision: 4, scale: 3, default: "1.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
  end

  create_table "big_pot_bases", primary_key: ["pot_id", "set_time"], force: :cascade do |t|
    t.string "pot_id", limit: 16, null: false
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_height", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_upper", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_floor", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "sewage_density", precision: 4, scale: 3, default: "1.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
  end

  create_table "big_pot_data_lasts", primary_key: "pot_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "height", precision: 5, scale: 2
    t.datetime "write_time"
  end

  create_table "big_pot_datas", primary_key: ["pot_id", "record_time"], force: :cascade do |t|
    t.string "pot_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "height", precision: 5, scale: 2
    t.datetime "write_time"
    t.index ["pot_id", "record_time"], name: "idx_big_pot_datas_pot_id_record_time", order: { record_time: "DESC NULLS LAST" }
    t.index ["pot_id"], name: "idx_big_pot_datas_pot_id"
    t.index ["record_time"], name: "idx_big_pot_datas_record_time"
    t.index ["write_time"], name: "idx_big_pot_datas_write_time"
  end

  create_table "bucket_outputs", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.integer "bucket_num1", limit: 2, default: 0, null: false
    t.integer "bucket_num2", limit: 2, default: 0, null: false
    t.decimal "bucket_weight1", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "bucket_weight2", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "run_time", limit: 2, default: 0, null: false
    t.decimal "output", precision: 7, scale: 3, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "idx_bucket_outputs_well_id_record_time", order: { record_time: "DESC NULLS LAST" }
  end

  create_table "bucket_press_temps", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3, default: "0.0", null: false
    t.decimal "temperature", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "idx_bucket_press_temps_well_id_record_time", order: { record_time: :desc }
  end

  create_table "casing_pressures", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "idx_casing_pressures_well_id_record_time", order: { record_time: "DESC NULLS LAST" }
  end

  create_table "check_valve_bases", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "pump_diameter", limit: 2, default: 0, null: false
    t.integer "piston_diameter", limit: 2, default: 0, null: false
    t.integer "pole_diameter", limit: 2, default: 0, null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "crude_density", precision: 4, scale: 3, default: "1.0", null: false
    t.decimal "water_ratio", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "gas_ratio", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "calc_coef", precision: 3, scale: 2, default: "1.0", null: false
    t.datetime "set_time", null: false
  end

  create_table "check_valve_dailys", primary_key: ["well_id", "start_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.decimal "average_output", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "average_weight", precision: 6, scale: 2, default: "0.0"
    t.datetime "write_time"
    t.index ["well_id", "start_time"], name: "check_valve_dailys_well_id_start_time", order: { start_time: :desc }
  end

  create_table "check_valves", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "temperature", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "up_time", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "down_time", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "cycle_num", limit: 2, default: 0, null: false
    t.decimal "output_volume", precision: 6, scale: 4, default: "0.0", null: false
    t.decimal "output_weight", precision: 6, scale: 4, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "check_valves_index"
    t.index ["well_id", "record_time"], name: "idx_check_valves_well_id_record_time_desc", order: { record_time: :desc }
  end

  create_table "close", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
  end

  create_table "daily_output_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "pump_diameter", limit: 2, default: 0, null: false
    t.decimal "pump_efficiency", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "average_output", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "theory_output", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "separator_output", precision: 6, scale: 2, default: "0.0", null: false
    t.integer "start_num", limit: 2, default: 0, null: false
    t.integer "stop_num", limit: 2, default: 0, null: false
    t.decimal "run_time", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "state", limit: 2, default: 0
    t.decimal "average_weight", precision: 6, scale: 2, default: "0.0"
  end

  create_table "daily_outputs", primary_key: ["well_id", "start_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "pump_diameter", limit: 2, default: 0, null: false
    t.decimal "pump_efficiency", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "average_output", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "theory_output", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "separator_output", precision: 6, scale: 2, default: "0.0", null: false
    t.integer "start_num", limit: 2, default: 0, null: false
    t.integer "stop_num", limit: 2, default: 0, null: false
    t.decimal "run_time", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "state", limit: 2, default: 0
    t.decimal "average_weight", precision: 6, scale: 2, default: "0.0"
    t.index ["well_id", "start_time"], name: "daily_outputs_well_id_start_time", order: { start_time: "DESC NULLS LAST" }
  end

  create_table "delete_indicator_diagrams", primary_key: ["well_id", "record_time", "delete_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.integer "calc_status", limit: 2, default: 0, null: false
    t.datetime "delete_time", null: false
  end

  create_table "device_types", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  create_table "dicts", id: :serial, force: :cascade do |t|
    t.string "type", limit: 255
    t.string "name", limit: 255
    t.integer "value"
  end

  create_table "electric_diagrams", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "active_powers", null: false
    t.datetime "write_time"
    t.index "date_trunc('hour'::text, record_time)", name: "idx_egraph_record_time_hour"
    t.index "date_trunc('hour'::text, record_time)", name: "idx_electric_diagrams_record_time_hour"
    t.index "lower((well_id)::text)", name: "electric_diagrams_lower_idx"
    t.index ["record_time"], name: "idx_electric_diagrams_record_time", order: :desc
    t.index ["well_id"], name: "idx_electric_diagrams_well_id"
  end

  create_table "electric_parameters", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "a_voltage", precision: 5, scale: 1
    t.decimal "b_voltage", precision: 5, scale: 1
    t.decimal "c_voltage", precision: 5, scale: 1
    t.decimal "a_current", precision: 5, scale: 2
    t.decimal "b_current", precision: 5, scale: 2
    t.decimal "c_current", precision: 5, scale: 2
    t.decimal "active_power", precision: 5, scale: 2
    t.decimal "reactive_power", precision: 5, scale: 2
    t.decimal "power_factor", precision: 4, scale: 3
    t.decimal "frequency", precision: 4, scale: 2
    t.decimal "total_energy", precision: 10, scale: 1
    t.integer "run_time", default: 0, null: false
    t.integer "total_time", default: 0, null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "electric_parameters_index"
  end

  create_table "electric_pump_base_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "std_voltage_old", limit: 2, default: 0, null: false
    t.integer "std_voltage", limit: 2, default: 0, null: false
    t.integer "voltage_upper_old", limit: 2, default: 0, null: false
    t.integer "voltage_upper", limit: 2, default: 0, null: false
    t.integer "voltage_floor_old", limit: 2, default: 0, null: false
    t.integer "voltage_floor", limit: 2, default: 0, null: false
    t.integer "std_current_old", limit: 2, default: 0, null: false
    t.integer "std_current", limit: 2, default: 0, null: false
    t.integer "current_upper_old", limit: 2, default: 0, null: false
    t.integer "current_upper", limit: 2, default: 0, null: false
    t.integer "current_floor_old", limit: 2, default: 0, null: false
    t.integer "current_floor", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "rtu_id", limit: 2, default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.integer "status_type", limit: 2, default: 0, null: false
    t.integer "status_num", limit: 2, default: 0, null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.decimal "voltage_ratio", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "current_ratio", precision: 4, scale: 2, default: "1.0", null: false
  end

  create_table "electric_pump_bases", primary_key: ["well_id", "set_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "std_voltage_old", limit: 2, default: 0, null: false
    t.integer "std_voltage", limit: 2, default: 0, null: false
    t.integer "voltage_upper_old", limit: 2, default: 0, null: false
    t.integer "voltage_upper", limit: 2, default: 0, null: false
    t.integer "voltage_floor_old", limit: 2, default: 0, null: false
    t.integer "voltage_floor", limit: 2, default: 0, null: false
    t.integer "std_current_old", limit: 2, default: 0, null: false
    t.integer "std_current", limit: 2, default: 0, null: false
    t.integer "current_upper_old", limit: 2, default: 0, null: false
    t.integer "current_upper", limit: 2, default: 0, null: false
    t.integer "current_floor_old", limit: 2, default: 0, null: false
    t.integer "current_floor", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "rtu_id", limit: 2, default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.integer "status_type", limit: 2, default: 0, null: false
    t.integer "status_num", limit: 2, default: 0, null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.decimal "voltage_ratio", precision: 4, scale: 2, default: "1.0", null: false
    t.decimal "current_ratio", precision: 4, scale: 2, default: "1.0", null: false
    t.index ["well_id"], name: "idx_electric_pump_bases_well_id"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.string "user_id", limit: 255
    t.string "integer", limit: 255
    t.string "title", limit: 255
    t.string "string", limit: 255
    t.string "content", limit: 255
    t.string "text", limit: 255
    t.string "contact", limit: 255
    t.datetime "record_time"
    t.string "current_user_name", limit: 255
  end

  create_table "flowmeter_base_lasts", primary_key: "flow_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_instant_flow", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "std_instant_flow_upper", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "std_instant_flow_floor", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "flow_density", precision: 4, scale: 3, default: "1.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.decimal "instant_flow_measurement", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "total_flow_measurement", precision: 14, scale: 2, default: "0.0", null: false
  end

  create_table "flowmeter_bases", primary_key: ["flow_id", "set_time"], force: :cascade do |t|
    t.string "flow_id", limit: 16, null: false
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_instant_flow", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "std_instant_flow_upper", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "std_instant_flow_floor", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "flow_density", precision: 4, scale: 3, default: "1.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.decimal "instant_flow_measurement", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "total_flow_measurement", precision: 14, scale: 2, default: "0.0", null: false
  end

  create_table "flowmeter_data_lasts", primary_key: "flow_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "instant_flow", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "total_flow", precision: 14, scale: 2, default: "0.0", null: false
    t.datetime "write_time", null: false
  end

  create_table "flowmeter_datas", primary_key: ["flow_id", "record_time"], force: :cascade do |t|
    t.string "flow_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "instant_flow", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "total_flow", precision: 14, scale: 2, default: "0.0", null: false
    t.datetime "write_time", null: false
  end

  create_table "hour_outputs", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.text "link_codes", null: false
    t.text "link_indexes", null: false
    t.integer "point1", limit: 2, default: 0, null: false
    t.integer "point2", limit: 2, default: 0, null: false
    t.decimal "valid_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "load_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "lost_length", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "pump_diameter", limit: 2, default: 0, null: false
    t.decimal "crude_density", precision: 4, scale: 3, default: "1.0", null: false
    t.decimal "water_ratio", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "leak_output", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "output_volume", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "output_weight", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "theory_output", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "pump_efficiency", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "calc_coefficient", precision: 3, scale: 2, default: "0.0", null: false
    t.integer "calc_status", limit: 2, default: 0, null: false
    t.integer "point4", limit: 2, default: 0
    t.integer "point5", limit: 2, default: 0
    t.decimal "custom_valid_length", precision: 4, scale: 2, default: "0.0"
  end

  create_table "indicator_diagram_by_hands", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16
    t.datetime "record_time"
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0"
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0"
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0"
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0"
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0"
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0"
    t.integer "dot_num", limit: 2, default: 0
    t.text "moves"
    t.text "loads"
    t.integer "calc_status", limit: 2, default: 0
    t.datetime "write_time"
    t.index ["record_time"], name: "idx_indicator_diagrams_by_hands_record_time"
    t.index ["well_id"], name: "idx_indicator_diagrams_by_hands_well_id"
  end

  create_table "indicator_diagram_diagnosis_datasets", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.integer "calc_status", limit: 2, default: 0, null: false
    t.datetime "write_time"
    t.decimal "fu", precision: 7, scale: 3
    t.decimal "fd", precision: 7, scale: 3
    t.decimal "fum", precision: 7, scale: 3
    t.decimal "fdk", precision: 7, scale: 3
    t.decimal "fuk", precision: 7, scale: 3
    t.decimal "fdm", precision: 7, scale: 3
    t.decimal "fdk20", precision: 7, scale: 3
    t.decimal "fub", precision: 7, scale: 3
    t.decimal "fdb", precision: 7, scale: 3
    t.decimal "f1", precision: 7, scale: 3
    t.decimal "f2", precision: 7, scale: 3
    t.decimal "f3", precision: 7, scale: 3
    t.decimal "f4", precision: 7, scale: 3
    t.decimal "f5", precision: 7, scale: 3
    t.decimal "f6", precision: 7, scale: 3
    t.decimal "f7", precision: 7, scale: 3
    t.decimal "f8", precision: 7, scale: 3
    t.decimal "f9", precision: 7, scale: 3
    t.decimal "f10", precision: 7, scale: 3
    t.decimal "f11", precision: 7, scale: 3
    t.decimal "f12", precision: 7, scale: 3
    t.decimal "k1", precision: 7, scale: 3
    t.decimal "k2", precision: 7, scale: 3
    t.decimal "k3", precision: 7, scale: 3
    t.decimal "k4", precision: 7, scale: 3
    t.decimal "k5", precision: 7, scale: 3
    t.decimal "k6", precision: 7, scale: 3
    t.decimal "length_ratio", precision: 7, scale: 3
    t.text "result"
    t.text "measure"
    t.decimal "valid_length", precision: 4, scale: 2, default: "0.0"
  end

  create_table "indicator_diagrams", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.integer "calc_status", limit: 2, default: 0, null: false
    t.datetime "write_time"
    t.index "date_trunc('hour'::text, record_time)", name: "idx_indicator_diagrams_record_time_hour"
    t.index "date_trunc('hour'::text, record_time)", name: "idx_wgraph_record_time_hour"
    t.index ["calc_status"], name: "idx_indicator_diagrams_calc_status"
    t.index ["record_time"], name: "idx_indicator_diagrams_record_time", order: :desc
    t.index ["well_id", "record_time", "calc_status"], name: "idx_indicator_diagrams_well_id_record_time_calc_status", order: { record_time: :desc }
    t.index ["well_id", "write_time"], name: "idx_indicator_diagrams_well_id_write_time", order: { write_time: "DESC NULLS LAST" }
    t.index ["write_time"], name: "idx_indicator_diagrams_write_time", order: :desc
  end

  create_table "indicator_diagrams_dirty", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.integer "calc_status", limit: 2, default: 0, null: false
    t.datetime "write_time"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
  end

  create_table "mineries", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_mineries_on_company_id"
  end

  create_table "mix_pump_frequencies", primary_key: ["pump_id", "record_time"], force: :cascade do |t|
    t.string "pump_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "frequency", precision: 5, scale: 2
    t.datetime "write_time"
  end

  create_table "mix_pump_frequency_base_lasts", primary_key: "pump_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_frequency", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_frequency_upper", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_frequency_floor", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.decimal "measurement", precision: 5, scale: 2, default: "0.0", null: false
  end

  create_table "mix_pump_frequency_bases", primary_key: ["pump_id", "set_time"], force: :cascade do |t|
    t.string "pump_id", limit: 16, null: false
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_frequency", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_frequency_upper", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_frequency_floor", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.decimal "measurement", precision: 5, scale: 2, default: "0.0", null: false
  end

  create_table "mix_pump_frequency_lasts", primary_key: "pump_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "frequency", precision: 5, scale: 2
    t.datetime "write_time"
  end

  create_table "mix_pump_pressure_base_lasts", primary_key: "pump_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_pressure", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_pressure_upper", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_pressure_floor", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.decimal "measurement", precision: 5, scale: 2, default: "0.0", null: false
  end

  create_table "mix_pump_pressure_bases", primary_key: ["pump_id", "set_time"], force: :cascade do |t|
    t.string "pump_id", limit: 16, null: false
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_pressure", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_pressure_upper", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "std_pressure_floor", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.decimal "measurement", precision: 5, scale: 2, default: "0.0", null: false
  end

  create_table "mix_pump_pressure_lasts", primary_key: "pump_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 2
    t.datetime "write_time"
  end

  create_table "mix_pump_pressures", primary_key: ["pump_id", "record_time"], force: :cascade do |t|
    t.string "pump_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 2
    t.datetime "write_time"
  end

  create_table "oil_press_temps", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3, default: "0.0", null: false
    t.decimal "temperature", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "idx_oil_press_temps_well_id_record_time", order: { record_time: "DESC NULLS LAST" }
  end

  create_table "open", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16
  end

  create_table "operators", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255
    t.string "tel", limit: 255
    t.integer "owner_id"
    t.string "owner_type", limit: 255
    t.string "schedular", limit: 255
  end

  create_table "pipe_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "outer_diameter", limit: 2, default: 0, null: false
    t.integer "inner_diameter", limit: 2, default: 0, null: false
    t.integer "density", default: 7850, null: false
    t.decimal "elastic_modulus", precision: 5, scale: 4, default: "2.1", null: false
  end

  create_table "pole_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "outer_diameter", limit: 2, default: 0, null: false
    t.integer "inner_diameter", limit: 2, default: 0, null: false
    t.integer "density", default: 7850, null: false
    t.decimal "elastic_modulus", precision: 5, scale: 4, default: "2.1", null: false
  end

  create_table "region_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_region_users_on_region_id"
    t.index ["user_id"], name: "index_region_users_on_user_id"
  end

  create_table "region_wells", force: :cascade do |t|
    t.string "well_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_region_wells_on_region_id"
    t.index ["well_id"], name: "index_region_wells_on_well_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "title"
    t.integer "parent_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rod_pump_bases", primary_key: ["well_id", "set_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "pump_diameter", limit: 2, default: 0, null: false
    t.decimal "pump_depth", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "liquid_level", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "crude_density", precision: 4, scale: 3, default: "1.0", null: false
    t.decimal "water_ratio", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "separator_output", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "calc_coefficient", precision: 3, scale: 2, default: "1.0", null: false
    t.datetime "set_time", null: false
    t.index ["well_id", "set_time"], name: "idx_rod_pump_bases_well_id_set_time", order: { set_time: "DESC NULLS LAST" }
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "roles_abilities", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "ability_id"
  end

  create_table "run_times", primary_key: ["well_id", "start_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
  end

  create_table "schedulars", id: :serial, force: :cascade do |t|
    t.integer "operator_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "screw_pump_base_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "std_voltage_old", limit: 2, default: 0, null: false
    t.integer "std_voltage", limit: 2, default: 0, null: false
    t.integer "voltage_upper_old", limit: 2, default: 0, null: false
    t.integer "voltage_upper", limit: 2, default: 0, null: false
    t.integer "voltage_floor_old", limit: 2, default: 0, null: false
    t.integer "voltage_floor", limit: 2, default: 0, null: false
    t.integer "std_current_old", limit: 2, default: 0, null: false
    t.integer "std_current", limit: 2, default: 0, null: false
    t.integer "current_upper_old", limit: 2, default: 0, null: false
    t.integer "current_upper", limit: 2, default: 0, null: false
    t.integer "current_floor_old", limit: 2, default: 0, null: false
    t.integer "current_floor", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.integer "status_type", limit: 2, default: 0, null: false
    t.integer "status_num", limit: 2, default: 0, null: false
  end

  create_table "screw_pump_bases", primary_key: ["well_id", "set_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "std_voltage_old", limit: 2, default: 0, null: false
    t.integer "std_voltage", limit: 2, default: 0, null: false
    t.integer "voltage_upper_old", limit: 2, default: 0, null: false
    t.integer "voltage_upper", limit: 2, default: 0, null: false
    t.integer "voltage_floor_old", limit: 2, default: 0, null: false
    t.integer "voltage_floor", limit: 2, default: 0, null: false
    t.integer "std_current_old", limit: 2, default: 0, null: false
    t.integer "std_current", limit: 2, default: 0, null: false
    t.integer "current_upper_old", limit: 2, default: 0, null: false
    t.integer "current_upper", limit: 2, default: 0, null: false
    t.integer "current_floor_old", limit: 2, default: 0, null: false
    t.integer "current_floor", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.integer "status_type", limit: 2, default: 0, null: false
    t.integer "status_num", limit: 2, default: 0, null: false
  end

  create_table "sensor_types", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", limit: 255, null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "sewage_pool_base_lasts", primary_key: "pool_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_height", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_upper", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_floor", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "sewage_density", precision: 4, scale: 3, default: "1.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.integer "measurement", default: 2, null: false
  end

  create_table "sewage_pool_bases", primary_key: ["pool_id", "set_time"], force: :cascade do |t|
    t.string "pool_id", limit: 16, null: false
    t.integer "rtu_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.decimal "std_height", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_upper", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "std_height_floor", precision: 5, scale: 2, default: "5.0", null: false
    t.decimal "sewage_density", precision: 4, scale: 3, default: "1.0", null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.integer "station_id", default: 0, null: false
    t.integer "measurement", default: 2, null: false
  end

  create_table "sewage_pool_data_lasts", primary_key: "pool_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "height", precision: 5, scale: 2
    t.datetime "write_time"
  end

  create_table "sewage_pool_datas", primary_key: ["pool_id", "record_time"], force: :cascade do |t|
    t.string "pool_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "height", precision: 5, scale: 2
    t.datetime "write_time"
    t.index ["pool_id", "record_time"], name: "idx_sewage_pool_datas_pool_id_record_time", order: { record_time: "DESC NULLS LAST" }
    t.index ["pool_id"], name: "idx_sewage_pool_datas_pool_id"
    t.index ["record_time"], name: "idx_sewage_pool_datas_record_time"
    t.index ["write_time"], name: "idx_sewage_pool_datas_write_time"
  end

  create_table "sss", id: false, force: :cascade do |t|
    t.string "well_id", limit: 16
    t.datetime "record_time"
    t.integer "work_type_id", limit: 2
    t.datetime "write_time"
    t.integer "stop_type_id"
    t.string "stop_detail", limit: 100
  end

  create_table "start_stop_alarms", id: :serial, force: :cascade do |t|
    t.integer "xh"
    t.string "fl", limit: 255
    t.string "xm", limit: 255
    t.string "czsj", limit: 255
    t.string "yq", limit: 255
  end

  create_table "start_stop_contrls", primary_key: ["well_id", "start_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "start_time", null: false
    t.datetime "stop_time"
    t.integer "contrl_status", limit: 2, default: 0, null: false
    t.index ["well_id", "start_time"], name: "idx_start_stop_contrls_well_id_start_time", order: { start_time: :desc }
  end

  create_table "start_stop_types", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  create_table "start_stops", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.integer "work_type_id", limit: 2, default: 0, null: false
    t.integer "fault_code", limit: 2, default: 0, null: false
    t.datetime "write_time", null: false
    t.integer "stop_type_id"
    t.string "stop_detail", limit: 100
    t.index ["well_id", "record_time"], name: "idx_start_stops_well_id_record_time", order: { record_time: :desc }
  end

  create_table "station_bases", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
  end

  create_table "std_indicator_diagram_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.boolean "std_diagram_flag", default: false, null: false
    t.integer "max_load_percent_old", limit: 2, default: 0, null: false
    t.integer "max_load_percent", limit: 2, default: 0, null: false
    t.integer "min_load_percent_old", limit: 2, default: 0, null: false
    t.integer "min_load_percent", limit: 2, default: 0, null: false
    t.integer "area_percent_old", limit: 2, default: 0, null: false
    t.integer "area_percent", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.string "load_instruction", limit: 100
    t.string "area_instruction", limit: 100
    t.integer "std_type_colour", limit: 2, default: 0
  end

  create_table "std_indicator_diagram_offset_rates", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time"
    t.datetime "set_time"
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0"
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0"
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0"
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0"
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0"
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0"
    t.integer "pump_diameter", limit: 2, default: 0
    t.datetime "last_record_time"
    t.decimal "sampling_point_max_loads", precision: 5, scale: 2, default: [], array: true
    t.decimal "sampling_point_min_loads", precision: 5, scale: 2, default: [], array: true
    t.decimal "sampling_point_diagram_areas", precision: 6, scale: 2, default: [], array: true
  end

  create_table "std_indicator_diagrams", primary_key: ["well_id", "set_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "stroke_times", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "stroke_length", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "max_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "min_load", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "diagram_area", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "rod_power", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "dot_num", limit: 2, default: 0, null: false
    t.text "moves", null: false
    t.text "loads", null: false
    t.boolean "std_diagram_flag", default: false, null: false
    t.integer "max_load_percent_old", limit: 2, default: 0, null: false
    t.integer "max_load_percent", limit: 2, default: 0, null: false
    t.integer "min_load_percent_old", limit: 2, default: 0, null: false
    t.integer "min_load_percent", limit: 2, default: 0, null: false
    t.integer "area_percent_old", limit: 2, default: 0, null: false
    t.integer "area_percent", limit: 2, default: 0, null: false
    t.datetime "set_time", null: false
    t.string "load_instruction", limit: 100
    t.string "area_instruction", limit: 100
    t.integer "std_type_colour", limit: 2, default: 0
    t.index ["well_id", "set_time"], name: "idx_std_indicator_diagrams_well_id_set_time", order: { set_time: "DESC NULLS LAST" }
  end

  create_table "stop_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "minery_id", null: false
    t.index ["minery_id"], name: "index_teams_on_minery_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "password_hash", limit: 255
    t.string "password_salt", limit: 255
    t.integer "owner_id"
    t.string "owner_type", limit: 255
    t.string "tel", limit: 255
    t.boolean "is_logged_in"
    t.integer "login_failed_times"
    t.datetime "login_failed_last_time"
    t.string "last_login_ip", limit: 2550
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "last_login"
    t.string "status", default: "1"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "water_rate_dailys", primary_key: ["well_id", "start_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.decimal "average_rate", precision: 4, scale: 1, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "start_time"], name: "water_rate_dailys_index"
  end

  create_table "water_rates", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "instant_rate", precision: 4, scale: 1, default: "0.0", null: false
    t.decimal "minute_rate", precision: 4, scale: 1, default: "0.0", null: false
    t.decimal "hour_rate", precision: 4, scale: 1, default: "0.0", null: false
    t.datetime "write_time"
    t.index ["well_id", "record_time"], name: "water_rates_index"
  end

  create_table "water_station_bases", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.integer "team_id", null: false
    t.string "rtu_no", limit: 30
    t.integer "lc_num", limit: 2
    t.integer "ulc_num", limit: 2
  end

  create_table "water_station_data_lasts", primary_key: "station_id", id: :integer, default: nil, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3
    t.datetime "write_time"
  end

  create_table "water_station_datas", primary_key: ["station_id", "record_time"], force: :cascade do |t|
    t.integer "station_id", null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3
    t.datetime "write_time"
  end

  create_table "water_well_base_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.integer "station_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.decimal "assign_flow", precision: 9, scale: 4, default: "0.0"
    t.string "layer", limit: 100
    t.string "remark", limit: 200
    t.decimal "std_flow", precision: 9, scale: 4, default: "0.0"
    t.integer "std_flow_upper", limit: 2, default: 20
    t.integer "std_flow_floor", limit: 2, default: 20
    t.decimal "std_oil_pressure", precision: 9, scale: 4, default: "0.0"
    t.integer "std_oil_pressure_upper", limit: 2, default: 20
    t.integer "std_oil_pressure_floor", limit: 2, default: 20
    t.datetime "set_time"
  end

  create_table "water_well_bases", primary_key: ["well_id", "set_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "station_id", default: 0, null: false
    t.integer "device_id", limit: 2, default: 0, null: false
    t.integer "work_status", limit: 2, default: 0, null: false
    t.decimal "assign_flow", precision: 9, scale: 4, default: "0.0"
    t.string "layer", limit: 100
    t.string "remark", limit: 200
    t.decimal "std_flow", precision: 9, scale: 4, default: "0.0"
    t.integer "std_flow_upper", limit: 2, default: 20
    t.integer "std_flow_floor", limit: 2, default: 20
    t.decimal "std_oil_pressure", precision: 9, scale: 4, default: "0.0"
    t.integer "std_oil_pressure_upper", limit: 2, default: 20
    t.integer "std_oil_pressure_floor", limit: 2, default: 20
    t.datetime "set_time", null: false
  end

  create_table "water_well_data_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3
    t.decimal "instant_flow", precision: 7, scale: 4
    t.decimal "total_flow", precision: 10, scale: 4
    t.datetime "write_time"
  end

  create_table "water_well_datas", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "pressure", precision: 5, scale: 3
    t.decimal "instant_flow", precision: 7, scale: 4
    t.decimal "total_flow", precision: 10, scale: 4
    t.datetime "write_time"
  end

  create_table "weight_indicator_base_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.decimal "weight_upper_old", precision: 5, scale: 1, default: "10000.0", null: false
    t.decimal "weight_upper", precision: 5, scale: 1, default: "10000.0", null: false
    t.datetime "set_time", null: false
  end

  create_table "weight_indicator_bases", primary_key: ["well_id", "set_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.decimal "weight_upper_old", precision: 5, scale: 1, default: "10000.0", null: false
    t.decimal "weight_upper", precision: 5, scale: 1, default: "10000.0", null: false
    t.datetime "set_time", null: false
    t.index ["well_id", "set_time"], name: "idx_weight_indicator_bases_well_id_set_time", order: { set_time: "DESC NULLS LAST" }
  end

  create_table "weight_indicator_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.integer "data_num", limit: 2, default: 5, null: false
    t.text "weights", null: false
    t.datetime "write_time"
  end

  create_table "weight_indicators", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.integer "data_num", limit: 2, default: 5, null: false
    t.text "weights", null: false
    t.datetime "write_time"
    t.index "lower((well_id)::text)", name: "weight_indicators_lower_idx"
    t.index ["record_time"], name: "idx_weight_indicators_record_time", order: :desc
  end

  create_table "well_bases", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.string "well_name", limit: 40, null: false
    t.integer "team_id", default: 0, null: false
    t.integer "well_type_id", default: 0, null: false
    t.integer "station_id", default: 0
    t.integer "wire_type_id", default: 0
    t.decimal "longitude", precision: 9, scale: 6, default: "0.0"
    t.decimal "latitude", precision: 9, scale: 6, default: "0.0"
    t.integer "show_status", default: 1, null: false
    t.integer "alarm_status", default: 1, null: false
    t.integer "del_status", default: 0, null: false
    t.integer "statistic_status", default: 1, null: false
    t.index ["team_id"], name: "idx_well_bases_team_id"
  end

  create_table "well_pipe_relations", primary_key: ["well_id", "pipe_level"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "pipe_level", limit: 2, default: 0, null: false
    t.decimal "pipe_length", precision: 6, scale: 2, default: "0.0", null: false
    t.integer "pipe_type_id", null: false
  end

  create_table "well_pole_relations", primary_key: ["well_id", "pole_level"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "pole_level", limit: 2, default: 0, null: false
    t.decimal "pole_length", precision: 6, scale: 2, default: "0.0", null: false
    t.integer "pole_type_id", null: false
  end

  create_table "well_repaire_reports", id: :serial, force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.string "area", limit: 2000
    t.datetime "fill_time", null: false
    t.string "fill_person", limit: 40
    t.string "description", limit: 2000
    t.datetime "service_time"
    t.string "reason", limit: 2000
    t.string "repaire", limit: 2000
    t.string "repaire_person", limit: 40
    t.string "scene", limit: 2000
    t.string "removed", limit: 40
    t.string "confirm_person", limit: 40
    t.string "remark", limit: 2000
    t.integer "status", default: 0
    t.datetime "confirm_time"
  end

  create_table "well_running_parameter_lasts", primary_key: "well_id", id: :string, limit: 16, force: :cascade do |t|
    t.datetime "record_time", null: false
    t.decimal "dynamic_liquid_surface", precision: 10, scale: 2
  end

  create_table "well_running_parameters", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.datetime "record_time", null: false
    t.decimal "dynamic_liquid_surface", precision: 10, scale: 2
  end

  create_table "well_sensor_relations", primary_key: ["well_id", "sensor_type_id"], force: :cascade do |t|
    t.string "well_id", limit: 16, null: false
    t.integer "sensor_type_id", null: false
  end

  create_table "well_states", primary_key: ["well_id", "record_time"], force: :cascade do |t|
    t.serial "id", null: false
    t.string "well_id", limit: 16, null: false
    t.string "state", limit: 16, null: false
    t.string "note", limit: 100
    t.datetime "record_time", default: -> { "now()" }, null: false
  end

  create_table "well_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  create_table "wire_bases", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "minery_id", default: 0, null: false
    t.string "wire_type", limit: 100, null: false
  end

  add_foreign_key "alarms", "well_bases", column: "well_id", primary_key: "well_id", name: "alarms_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "audit_calculate_wells", "well_bases", column: "well_id", primary_key: "well_id", name: "audit_calculate_wells_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "big_pot_base_lasts", "well_bases", column: "pot_id", primary_key: "well_id", name: "big_pot_base_lasts_pot_id_fkey"
  add_foreign_key "big_pot_bases", "well_bases", column: "pot_id", primary_key: "well_id", name: "big_pot_bases_pot_id_fkey"
  add_foreign_key "big_pot_data_lasts", "well_bases", column: "pot_id", primary_key: "well_id", name: "big_pot_data_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "big_pot_datas", "well_bases", column: "pot_id", primary_key: "well_id", name: "big_pot_datas_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "bucket_outputs", "well_bases", column: "well_id", primary_key: "well_id", name: "bucket_outputs_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "bucket_press_temps", "well_bases", column: "well_id", primary_key: "well_id", name: "bucket_press_temps_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "casing_pressures", "well_bases", column: "well_id", primary_key: "well_id", name: "casing_pressures_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "check_valve_bases", "well_bases", column: "well_id", primary_key: "well_id", name: "check_valve_bases_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "daily_output_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "daily_output_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "daily_outputs", "well_bases", column: "well_id", primary_key: "well_id", name: "daily_outputs_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "delete_indicator_diagrams", "well_bases", column: "well_id", primary_key: "well_id", name: "delete_indicator_diagrams_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "electric_diagrams", "well_bases", column: "well_id", primary_key: "well_id", name: "electric_diagrams_well_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "electric_pump_base_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "electric_pump_base_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "electric_pump_bases", "well_bases", column: "well_id", primary_key: "well_id", name: "electric_pump_bases_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "flowmeter_base_lasts", "well_bases", column: "flow_id", primary_key: "well_id", name: "flowmeter_base_lasts_flow_id_fkey"
  add_foreign_key "flowmeter_bases", "well_bases", column: "flow_id", primary_key: "well_id", name: "flowmeter_bases_flow_id_fkey"
  add_foreign_key "flowmeter_data_lasts", "well_bases", column: "flow_id", primary_key: "well_id", name: "flowmeter_data_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "flowmeter_datas", "well_bases", column: "flow_id", primary_key: "well_id", name: "flowmeter_datas_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "indicator_diagrams", "well_bases", column: "well_id", primary_key: "well_id", name: "indicator_diagrams_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "mineries", "companies", name: "mineries_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "mix_pump_frequencies", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_frequencies_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "mix_pump_frequency_base_lasts", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_frequency_base_lasts_pump_id_fkey"
  add_foreign_key "mix_pump_frequency_bases", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_frequency_bases_pump_id_fkey"
  add_foreign_key "mix_pump_frequency_lasts", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_frequency_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "mix_pump_pressure_base_lasts", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_pressure_base_lasts_pump_id_fkey"
  add_foreign_key "mix_pump_pressure_bases", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_pressure_bases_pump_id_fkey"
  add_foreign_key "mix_pump_pressure_lasts", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_pressure_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "mix_pump_pressures", "well_bases", column: "pump_id", primary_key: "well_id", name: "mix_pump_pressures_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "oil_press_temps", "well_bases", column: "well_id", primary_key: "well_id", name: "oil_press_temps_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "rod_pump_bases", "well_bases", column: "well_id", primary_key: "well_id", name: "rod_pump_bases_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "run_times", "well_bases", column: "well_id", primary_key: "well_id", name: "run_times_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "screw_pump_base_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "screw_pump_base_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "screw_pump_bases", "well_bases", column: "well_id", primary_key: "well_id", name: "screw_pump_bases_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "sewage_pool_base_lasts", "well_bases", column: "pool_id", primary_key: "well_id", name: "sewage_pool_base_lasts_pool_id_fkey"
  add_foreign_key "sewage_pool_bases", "well_bases", column: "pool_id", primary_key: "well_id", name: "sewage_pool_bases_pool_id_fkey"
  add_foreign_key "sewage_pool_data_lasts", "well_bases", column: "pool_id", primary_key: "well_id", name: "sewage_pool_data_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "sewage_pool_datas", "well_bases", column: "pool_id", primary_key: "well_id", name: "sewage_pool_datas_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "start_stop_contrls", "well_bases", column: "well_id", primary_key: "well_id", name: "start_stop_contrls_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "start_stops", "well_bases", column: "well_id", primary_key: "well_id", name: "start_stops_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "std_indicator_diagram_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "std_indicator_diagram_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "std_indicator_diagrams", "well_bases", column: "well_id", primary_key: "well_id", name: "std_indicator_diagrams_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "teams", "mineries", name: "teams_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_station_bases", "teams", name: "water_station_bases_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_station_data_lasts", "water_station_bases", column: "station_id", name: "water_station_data_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_station_datas", "water_station_bases", column: "station_id", name: "water_station_datas_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_well_base_lasts", "water_station_bases", column: "station_id", name: "water_well_base_lasts_station_id_fkey"
  add_foreign_key "water_well_base_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "water_well_base_lasts_well_id_fkey"
  add_foreign_key "water_well_bases", "water_station_bases", column: "station_id", name: "water_well_bases_station_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_well_bases", "well_bases", column: "well_id", primary_key: "well_id", name: "water_well_bases_well_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_well_data_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "water_well_data_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "water_well_datas", "well_bases", column: "well_id", primary_key: "well_id", name: "water_well_datas_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "weight_indicator_base_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "weight_indicator_base_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "weight_indicator_bases", "well_bases", column: "well_id", primary_key: "well_id", name: "weight_indicator_bases_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "weight_indicator_lasts", "well_bases", column: "well_id", primary_key: "well_id", name: "weight_indicator_lasts_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "weight_indicators", "well_bases", column: "well_id", primary_key: "well_id", name: "weight_indicators_well_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_bases", "teams", name: "well_base_team_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_bases", "well_types", name: "well_base_well_type_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_pipe_relations", "pipe_types", name: "well_pipe_relations_pipe_type_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_pipe_relations", "well_bases", column: "well_id", primary_key: "well_id", name: "well_pipe_relations_well_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_pole_relations", "pole_types", name: "well_pole_relations_pole_type_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_pole_relations", "well_bases", column: "well_id", primary_key: "well_id", name: "well_pole_relations_well_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_sensor_relations", "device_types", column: "sensor_type_id", name: "well_sensor_relations_sensor_type_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "well_sensor_relations", "well_bases", column: "well_id", primary_key: "well_id", name: "well_sensor_relations_well_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "wire_bases", "mineries", name: "wire_bases_fkey", on_update: :cascade, on_delete: :restrict
end
