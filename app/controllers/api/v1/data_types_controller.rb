class Api::V1::DataTypesController < Api::V1::BaseController
  def get_sensor_typelist
    render json: DataType.order(:id).all
  end
end
