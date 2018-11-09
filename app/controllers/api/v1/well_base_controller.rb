class Api::V1::WellBaseController < Api::V1::BaseController
	def get_wellList
		render json: WellBase.where(show_status: 1).all
	end

	def get_vux_well_list
		render json: WellBase.select(:well_id, :well_name).where(show_status: 1).all
	end
	
end
