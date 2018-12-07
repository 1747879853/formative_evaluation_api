class Api::V1::SensorTypesController < Api::V1::BaseController
  def get_sensor_typelist
    render json: SensorType.order(:id).all
  end
end