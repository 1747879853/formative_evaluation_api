class Api::V1::WellAlarmController < Api::V1::BaseController
	def get_alarm_list
		day=WellAlarm.where("record_time >= ?",Time.now.beginning_of_day).count
		week=WellAlarm.where("record_time >= ?",Time.now.beginning_of_week).count
		month=WellAlarm.where("record_time >= ?",Time.now.beginning_of_month).count
		render json: {day:day,week:week,month:month}
	end
end