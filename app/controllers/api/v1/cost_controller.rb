class Api::V1::CostController < Api::V1::BaseController
  # before_action :authorize
  
  def get_costlist
    # unauthorized and return unless Auth.check('Admin/daily_summary/costlist', current_user)
    render json: Cost.where(parent_id: 0).all
  end

  def post_costlist
  	begin
      cost = Cost.new(cost_params)
      if cost.save!
        render json: cost
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end



  def delete_costlist

    begin
      cost = Cost.find(params.require(:params)[:id])
      if cost.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_costlist

    begin
      cost = Cost.find(params.require(:params)[:id])
      if cost.update(params.require(:params).permit(:title,))
        render json: cost
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  private

  def cost_params
    params.require(:params).permit(:title,:parent_id)
  end

end