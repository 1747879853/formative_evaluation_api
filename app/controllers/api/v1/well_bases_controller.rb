class Api::V1::WellBasesController < Api::V1::BaseController
	def get_wellList
		render json: WellBase.where(show_status: 1).all
	end

  # def get_wellListSelect
  #
  # end

	def get_vux_well_list
		render json: WellBase.select(:well_id, :well_name).where(show_status: 1).all
	end
	
	def get_yesterday_output
		a=DailyOutputLast.where("end_time = ?",Time.now.beginning_of_day+8.hour).sum(:average_weight)
		render json: { a: a.to_s }
	end

	def get_daily_well
		a=StartStopLast.where("record_time >= ? and work_type_id = ?",Time.now.beginning_of_day,1).count
		render json: {  a: a }
	end
end
