class Api::V1::WellWgraphController < Api::V1::BaseController

	def get_wgs
		wb = WellBase.find(params[:id])
		wgs = wb.well_w_graph.first(3)
		render json: wgs
	end	

end
