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
				id_sensor_type = WellSensorRelation.select("distinct well_id").map{|p| p.well_id}
				params["sensor_types"].each do |x|
				  id_sensor_type = id_sensor_type&WellSensorRelation.select("distinct well_id").where(sensor_type_id: x).map{|p| p.well_id}
				end
			elsif params["is_sensor_type_box"] == "false"
				id_sensor_type = WellSensorRelation.where(sensor_type_id: params["sensor_types"]).map{|p| p.well_id}
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
			# 	wellbases = WellBase.select(:well_id, :well_name).where("well_id in (?)",id_status).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			# wellbases = WellBase.select(:well_id, :well_name).where("well_id in (?)",id_status).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			wellbases = WellBase.select(:well_id, :well_name).where("well_id in (?)",id_status).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			wellbases_length = WellBase.select(:well_id, :well_name).where("well_id in (?)",id_status).length
			# wellbase_ids = WellBase.where("well_id in (?)",id_status).map{|p| p.well_id}
			# 			# wellbases_length = wellbase_ids.length
		else
			wellbases = WellBase.select(:well_id, :well_name).where(show_status: 1).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
			wellbases_length = WellBase.select(:well_id, :well_name).where(show_status: 1)
			# wellbase_ids = WellBase.where(show_status: 1).map{|p| p.well_id}
			# wellbases_length = wellbase_ids.length
		end

		# # case_station 1 开停机状态排序 2 油井类型排序 3 产液量排序
		# # .limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
		# case params["case_station"]
		# when "2" # 油井类型排序
		# 	if params["descOrasc"] == "asc"
		# 		wellbases = WellBase.select(:well_id,:well_name).where("well_id in (?)",wellbase_ids).order(:well_type_id).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
		# 	else
		# 		wellbases = WellBase.select(:well_id,:well_name).where("well_id in (?)",wellbase_ids).order(well_type_id: :desc).limit(params["page_size"]).offset(((params["current_page"]).to_i-1)*(params["page_size"]).to_i).as_json
		# 	end
		# when "3" # 产液量排序 最新产液量：select * from daily_output_lasts ;
		# 	if params["descOrasc"] == "asc"
		# 		# wellbases =
		# 	else
		#
		# 	end
		# else # 开停机状态排序    开停机状态：select * from start_stop_lasts order by record_time desc;
		# 	if params["descOrasc"] == "asc"
		# 		if id_status.nil?
		#
		# 		else
		#
		# 		end
		# 	else
		# 		if id_status.nil?
		#
		# 		else
		#
		# 		end
		# 	end
		# end

		wellbases.each do |i|
			# select string_agg(foo.name,',') from (select well_sensor_relations.well_id,well_sensor_relations.sensor_type_id,sensor_types.name from well_sensor_relations left join sensor_types on sensor_types.id = well_sensor_relations.sensor_type_id where well_sensor_relations.well_id = 'SDWT-IDSA01') as foo
			# 传感器类型
			foo = ActiveRecord::Base.connection.execute("select string_agg(foo.name,',') from (select well_sensor_relations.well_id,well_sensor_relations.sensor_type_id,sensor_types.name from well_sensor_relations left join sensor_types on sensor_types.id = well_sensor_relations.sensor_type_id where well_sensor_relations.well_id = '"+i["well_id"]+"') as foo")
			i["sensor"] = foo[0]["string_agg"]
			# 开停机状态
			startStopLast = StartStopLast.where(well_id: i["well_id"]).select(:well_id,:record_time,:work_type_id).to_a
			flag = 0
			if startStopLast.length > 0
				if startStopLast[0].work_type_id != 1
					if startStopLast[0].work_type_id == 2
						if startStopLast[0].record_time.year == Time.now.year and startStopLast[0].record_time.month == Time.now.month and startStopLast[0].record_time.day == Time.now.day
							flag = 1
						else
							flag = -1
						end
					else
						flag = -1
					end
				end
			else
				flag = -2
			end
			i["isStart"] = flag
		  # 产液量

		end
		render json: {"wells":wellbases,"length":wellbases_length}
	end

	def get_vux_well_list
		render json: WellBase.select(:well_id, :well_name).where(show_status: 1).all
  end

  def get_well_names
    # h = {
    #     "well_names": WellBase.all.map{|p| p.well_name},
    # }
    # render json: h
    render json: WellBase.select("well_id,well_name").all
  end
	
end
