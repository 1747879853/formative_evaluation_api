class Api::V1::WellBasesController < Api::V1::BaseController
	def get_wellList
		render json: WellBase.where(show_status: 1).all
	end
end
