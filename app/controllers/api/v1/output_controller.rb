class Api::V1::OutputController < Api::V1::BaseController
	def get_vux_yesterday_output
		render json: DailyOutputLast.where("end_time = ?",Time.now.beginning_of_day+8.hour).sum(:average_weight)
	end

	def get_vux_output_list
		render json: DailyOutput.where("well_id = ?",params[:id]).order("end_time desc").first(7)
	end 
end