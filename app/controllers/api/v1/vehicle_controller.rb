class Api::V1::VehicleController < Api::V1::BaseController

  def get_vehiclelist

    begin
        render json: RuihongCar.all
    rescue Exception => e
      render json: { msg: e }, status: 500
    end

  end

  def post_vehiclelist

    begin
      a = params.require(:params)[:up_time]
      b = params.require(:params)[:down_time]
      c = params.require(:params)[:carno]
      car = RuihongCar.where('carno like ? and (out_time between ? and ? or in_time between ? and ?)',['%',c, '%'].join,a,b,a,b)
      render json: car
    rescue Exception => e
      render json: { msg: e }, status: 500
    end

  end

end