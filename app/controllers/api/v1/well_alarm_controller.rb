class Api::V1::WellAlarmController < Api::V1::BaseController
	def get_alarm_list
		day=WellAlarm.where("record_time >= ?",Time.now.beginning_of_day).count
		week=WellAlarm.where("record_time >= ?",Time.now.beginning_of_week).count
		month=WellAlarm.where("record_time >= ?",Time.now.beginning_of_month).count
		render json: {day:day,week:week,month:month}
	end

	def get_vux_alarm
		a=WellAlarm.select(:well_id, :record_time, :alarm_type_id).where("well_id = ?",params[:id]).order("record_time desc").first(7)
		b = Array.new
		a.each do |i|
	  		b.push(AlarmType.get_alarm_type_string_by_id(i.alarm_type_id))
	  	end
		render json: {a: a,b: b}
	end
end