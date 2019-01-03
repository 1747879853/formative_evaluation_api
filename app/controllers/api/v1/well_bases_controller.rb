class Api::V1::WellBasesController < Api::V1::BaseController
	def get_wellList
		render json: WellBase.where(show_status: 1).all
	end

  def get_well_list_select
		# 先选择符合条件的well_id
		# 单选
		# 状态 -1 正在运行 0  长停 1
		if params["is_status_box"] == "true"
			# 多选
			# [{"id":3,"name":"开机状态"},{"id":4,"name":"当日停机状态"},{"id":5,"name":"长时间停机状态"}]
			# 3 4 5 3,4 3,5 4,5
			# 3 4 5 7   8   9
			# id1 = StartStopLast.select(:well_id).where(work_type_id: 1).map {|i| i.well_id }
			# id2 = StartStopLast.select(:well_id).where("record_time >= date_trunc('day', now()) and work_type_id = 2").map {|i| i.well_id }
			# id3 = StartStopLast.select(:well_id).where("well_id not in (?)",StartStopLast.select(:well_id).where("record_time = current_date and work_type_id = 2")).where("well_id not in (?)",StartStopLast.select(:well_id).where(work_type_id: 1)).map {|i| i.well_id }
			case params["status"]
			when "3"
				id_status = StartStopLast.select(:well_id).where(work_type_id: 1).map {|i| i.well_id }
			when "4"
				id_status = StartStopLast.select(:well_id).where("record_time >= date_trunc('day', now()) and work_type_id = 2").map {|i| i.well_id }
			when "5"
				id_status = StartStopLast.select(:well_id).where("well_id not in (?)",StartStopLast.select(:well_id).where("record_time = current_date and work_type_id = 2")).where("well_id not in (?)",StartStopLast.select(:well_id).where(work_type_id: 1)).map {|i| i.well_id }
			when "7"
				id_status = StartStopLast.select(:well_id).where(work_type_id: 1).map {|i| i.well_id }+StartStopLast.select(:well_id).where("record_time >= date_trunc('day', now()) and work_type_id = 2").map {|i| i.well_id }
			when "8"
				id_status = StartStopLast.select(:well_id).where(work_type_id: 1).map {|i| i.well_id }+StartStopLast.select(:well_id).where("well_id not in (?)",StartStopLast.select(:well_id).where("record_time = current_date and work_type_id = 2")).where("well_id not in (?)",StartStopLast.select(:well_id).where(work_type_id: 1)).map {|i| i.well_id }
			else
				id_status = StartStopLast.select(:well_id).where("record_time >= date_trunc('day', now()) and work_type_id = 2").map {|i| i.well_id }+StartStopLast.select(:well_id).where("well_id not in (?)",StartStopLast.select(:well_id).where("record_time = current_date and work_type_id = 2")).where("well_id not in (?)",StartStopLast.select(:well_id).where(work_type_id: 1)).map {|i| i.well_id }
			end
		elsif params["is_status_box"] == "false"
			if params["status"] == '-1'
				# 长停
				id_status = StartStopLast.select(:well_id).where("well_id not in (?)",StartStopLast.select(:well_id).where("record_time = current_date and work_type_id = 2")).where("well_id not in (?)",StartStopLast.select(:well_id).where(work_type_id: 1)).map {|i| i.well_id }
			elsif params["status"] == '1'
				# 当日停
				id_status = StartStopLast.select(:well_id).where("record_time >= date_trunc('day', now()) and work_type_id = 2").map {|i| i.well_id }
			else
				id_status = StartStopLast.select(:well_id).where(work_type_id: 1).map {|i| i.well_id }
			end
		end

		# 区块选择
		if params["is_region"] == "true"
			ids = params["regions"]
			temp = []
			ids.each do |i|
				id_temp = Region.where(parent_id: i).map{|p| p.id}
				if id_temp.length > 0
					temp += id_temp
				end
			end
			ids += temp
			if id_status.nil?
				if params["regions"].length > 0
					id_status = RegionWell.where("region_id in (?)",ids).map{|i| i.well_id}
				end
			else
				if params["regions"].length > 0
					id_region =  RegionWell.where("region_id in (?)",ids).map{|i| i.well_id} if params["regions"]
					id_status = id_status&id_region
				end
			end
		end

		#传感器类型
		if params["is_sensor_type_box"] == "true" or params["is_sensor_type_box"] == "false"
			if params["is_sensor_type_box"] == "true"
				# 这个条件是或还是且？且
				id_sensor_type = WellDataRelation.select("distinct well_id").map{|p| p.well_id}
				params["sensor_types"].each do |x|
				  id_sensor_type = id_sensor_type&WellDataRelation.select("distinct well_id").where(data_type: x).map{|p| p.well_id}
				end
			elsif params["is_sensor_type_box"] == "false"
				id_sensor_type = WellDataRelation.where(data_type: params["sensor_types"]).map{|p| p.well_id}
			end
			if id_status.nil?
				id_status = id_sensor_type
			else
				id_status = id_status&id_sensor_type
			end
		end

		if params["is_well_type_box"] == "false" or params["is_well_type_box"] == "true"
			if params["is_well_type_box"] == "false"
				id_well_type = WellBase.where(well_type_id: params["well_types"]).map{|p| p.well_id}
			elsif params["is_well_type_box"] == "true"
				id_well_type = WellBase.where("well_type_id in (?)",params["well_types"]).map{|p| p.well_id}
			end
			if id_status.nil?
				id_status = id_well_type
			else
				id_status = id_status&id_well_type
			end
		end

		if params["is_well_name"] == "true"
			id_well_name = WellBase.where("well_name like CONCAT('%',(?),'%')", params["well_name"]).map{|p| p.well_id}
			if id_status.nil?
				id_status = id_well_name
			else
				id_status = id_status&id_well_name
			end
		end

		if(!id_status.nil?)
			# 选择情况
			# wellbases = WellBase.select(:well_id, :well_name).where("well_id in (?)",id_status).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			# wellbases_length = WellBase.select(:well_id, :well_name).where("well_id in (?)",id_status).length
			wellbase_ids = WellBase.where("well_id in (?)",id_status).map{|p| p.well_id}
			wellbases_length = wellbase_ids.length
		else
			# wellbases = WellBase.select(:well_id, :well_name).where(show_status: 1).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			# wellbases_length = WellBase.select(:well_id, :well_name).where(show_status: 1).length
			wellbase_ids = WellBase.where(show_status: 1).map{|p| p.well_id}
			wellbases_length = wellbase_ids.length
		end

		# case_station 1 开停机状态排序 2 油井类型排序 3 产液量排序
		# .limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
		case params["case_station"]
		when "2" # 油井类型排序
			if params["descOrasc"] == "asc"
				well_ids = WellBase.select(:well_id,:well_name).where("well_id in (?)",wellbase_ids).order(:well_type_id).map{|p| p.well_id}
			else
				well_ids = WellBase.select(:well_id,:well_name).where("well_id in (?)",wellbase_ids).order(well_type_id: :desc).map{|p| p.well_id}
			end
			wellbase_id_list = well_ids[((params["current_page"]).to_i-1)*(params["page_size"]).to_i,params["page_size"].to_i]
		when "3" # 产液量排序 最新产液量：select * from daily_output_lasts ;
			daily_output_all_ids = DailyOutputLast.all.map{|p| p.well_id}
			if params["descOrasc"] == "asc" #从小到大
				# 在头部
				other_ids = wellbase_ids - daily_output_all_ids
				wellbases_other_ids = wellbase_ids - other_ids
				wellbases_other_ids_sorted = DailyOutputLast.where("well_id in (?)",wellbases_other_ids).order(:average_weight).map{|x| x.well_id}
				well_ids = other_ids+wellbases_other_ids_sorted
				# wellbases = WellBase.select(:well_id,:well_name).where("well_id in (?)",well_ids).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
				# wellbase_id_list = well_ids[((params["current_page"]).to_i-1)*(params["page_size"]).to_i,((params["current_page"]).to_i-1)*(params["page_size"]).to_i+(params["page_size"].to_i)]
			else #从大到小
				# 在尾部
				other_ids = wellbase_ids - daily_output_all_ids
				wellbases_other_ids = wellbase_ids - other_ids
				wellbases_other_ids_sorted = DailyOutputLast.where("well_id in (?)",wellbases_other_ids).order(average_weight: :desc).map{|x| x.well_id}
				well_ids = wellbases_other_ids_sorted+other_ids
				# wellbases = WellBase.select(:well_id,:well_name).where("well_id in (?)",well_ids).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			end
			wellbase_id_list = well_ids[((params["current_page"]).to_i-1)*(params["page_size"]).to_i,params["page_size"].to_i]
		else # 开停机状态排序    开停机状态：select * from start_stop_lasts order by record_time desc;
			start_stop_last_all_ids = StartStopLast.all.map{|p| p.well_id}
			if params["descOrasc"] == "desc" #从大到小
				# 在头部
				other_ids = wellbase_ids - start_stop_last_all_ids
				wellbases_other_ids = wellbase_ids - other_ids
				wellbases_other_ids_sorted = StartStopLast.where("well_id in (?)",wellbases_other_ids).order("work_type_id desc,record_time asc").map{|x| x.well_id}
				well_ids = other_ids+wellbases_other_ids_sorted
				# wellbases = WellBase.select(:well_id,:well_name).where("well_id in (?)",well_ids).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			else #从小到大
				# 在尾部
				other_ids = wellbase_ids - start_stop_last_all_ids
				wellbases_other_ids = wellbase_ids - other_ids
				wellbases_other_ids_sorted = StartStopLast.where("well_id in (?)",wellbases_other_ids).order("work_type_id asc,record_time asc").map{|x| x.well_id}
				well_ids = wellbases_other_ids_sorted+other_ids
				# wellbases = WellBase.select(:well_id,:well_name).where("well_id in (?)",well_ids).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			end
			wellbase_id_list = well_ids[((params["current_page"]).to_i-1)*(params["page_size"]).to_i,params["page_size"].to_i]
		end
		wellbases = []

		wellbase_id_list.each do |i|
			h = {}
			h["well_id"] = i
			h["well_name"] = i
			# 传感器类型
			foo = ActiveRecord::Base.connection.execute("select string_agg(foo.name,',') from (select well_data_relations.well_id,well_data_relations.data_type,data_types.name from well_data_relations left join data_types on data_types.id = well_data_relations.data_type where well_data_relations.well_id = '"+i+"') as foo")
			h["sensor"] = foo[0]["string_agg"]
			# 开停机状态
			startStopLast = StartStopLast.where(well_id: i).as_json
			if startStopLast.length>0
				h["isStart"] = startStopLast[0][:status]
			else
				h["isStart"] = -2
			end

		  # 产液量
			s = DailyOutputLast.where(well_id: i).as_json
			if s.length == 1
				h["flulidProduction"]=s[0][:daily_output_avg].to_f
			else
				h["flulidProduction"]=0
			end
			wellbases.append(h)
		end
		render json: {"wells":wellbases,"length":wellbases_length}
	end

  def get_well_names
    # h = {
    #     "well_names": WellBase.all.map{|p| p.well_name},
    # }
    # render json: h
    render json: WellBase.select("well_id,well_name").all
	end

	def get_sensor_well_region_list
		# datatype = DataType.order(:id).all
		# welltype = WellType.all
		# region = Region.where(parent_id: 0).all
		render json: {'datatypes': DataType.order(:id).all,'welltypes'=> WellType.all, 'regions'=> Region.where(parent_id: 0).all}
	end

	def get_vux_well_list
		render json: WellBase.select(:well_id, :well_name).where(show_status: 1).all
	end

	def get_vux_daily_well
		render json: StartStopLast.where("work_type_id = ?",1).count
	end

end
