class  Api::V1::WellTypesController < Api::V1::BaseController
  def get_well_typelist
    render json: WellType.all
  end
end