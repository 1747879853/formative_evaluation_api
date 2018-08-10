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
      @s = params.require(:params)[:s_time]
      @e = params.require(:params)[:e_time]
      @c = params.require(:params)[:carno]
      # car = RuihongCar.where('carno like ? and (out_time between ? and ? or in_time between ? and ?)',['%',c, '%'].join,a,b,a,b)
      car = RuihongCar.where(in_time: @s..@e).where("carno LIKE ?","%#{@c}%").or(RuihongCar.where( out_time: @s..@e).where("carno LIKE ?","%#{@c}%")).order(:created_at)

      render json: car
    rescue Exception => e
      render json: { msg: e }, status: 500
    end

  end

end

@vehicle_all = RuihongCar.where(in_time: @s..@e).or(RuihongCar.where( out_time: @s..@e)).order(:created_at)