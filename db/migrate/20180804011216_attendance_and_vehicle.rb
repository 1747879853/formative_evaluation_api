class AttendanceAndVehicle < ActiveRecord::Migration[5.2]
  def change
    create_table :ruihong_cars do |t|
        t.string :cname
        t.integer :p_key
        t.string :carno
        t.datetime :in_time
        t.datetime :out_time
        t.string :i_picno
        t.string :o_picno

        t.timestamps
    end

    create_table :local_time_records do |t|
        t.integer :clock_id
        t.string :workno
        t.string :card_id
        t.datetime :sign_time
        t.integer :mark
        t.integer :flag
        t.string :bill_id
        t.string :eventname
        t.integer :position
        t.datetime :collecttime
        t.timestamps
    end
    create_table :local_depart_records do |t|
        t.string :depart_id
        t.string :inside_id
        t.string :group_id
        t.string :depart_name
        t.string :principal
        t.string :emp_prefix
        t.timestamps
    end    
    create_table :employees do |t|
        t.string :workno         #***
        t.string :card_id
        t.string :name    #***
        t.integer :id_type
        t.string :id_card
        t.boolean :no_sign
        t.string :depart_id
        t.string :job_id
        t.string :rule_id
        t.string :edu_id
        t.string :native_id
        t.string :nation_id
        t.string :status_id
        t.integer :card_kind
        t.boolean :put_up
        t.string :bed_id
        t.string :group_id
        t.datetime :birth   #***
        t.string :gender    #***
        t.string :marriage
        t.string :email
        t.string :phone_code
        t.string :address
        t.string :post_code
        t.string :link_man
        t.datetime :hire_date
        t.datetime :contract_date
        t.datetime :contract_over_date
        t.datetime :leave_date
        t.string :dismission_type_id
        t.string :leave_course
        t.decimal :pre_balance, precision: 20, scale: 0
        t.integer :pre_sequ
        t.boolean :icid
        t.integer :rest_kind
        t.string :rest_days  
        t.integer :worktime_kind
        t.string :shifts
        t.string :shift_id
        t.decimal :work_hrs, precision: 20, scale: 0
        t.string :remark
        t.boolean :zlgput_up
        t.integer :access_level
        t.string :access_pwd
        t.string :contact_phone
        t.boolean :bless
        t.string :foodtype
        t.string :graduate_college
        t.string :specially
        t.string :introducer
        t.datetime :redeploy_date     
        t.datetime :redeploy_date2   
        t.decimal :work_age, precision: 20, scale: 0
        t.string :work_status
        t.datetime :social_insurance_date   
        t.decimal :social_insurance_money, precision: 20, scale: 0
        t.boolean :auto_shift
        t.integer :inwork_age
        t.integer :age
        t.datetime :stop_social_insurance_date   
        t.datetime :stop_job_date
        t.datetime :long_holiday_date 
        t.string :contact_labour
        t.datetime :be_regular_date  
        t.string :dorm_building
        t.string :salary_account
        t.string :password
        t.string :password_digest   #***
        t.string :bank_no
        t.boolean :is_black
        t.boolean :is_white
        t.datetime :balance_time
        t.decimal :day_consume, precision: 20, scale: 0
        t.decimal :day_max_money, precision: 20, scale: 0
        t.decimal :day_time, precision: 20, scale: 0
        t.decimal :time_max_money, precision: 20, scale: 0
        t.float :day_total_money
        t.integer :day_total_time
        t.boolean :is_over_time
        t.boolean :access_holiday
        t.boolean :left_holiday
        t.datetime :left_limit_date
        t.attachment :image
        t.string :photo
    end
  end
end
