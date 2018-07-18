class Api::V1::OrdersController < Api::V1::BaseController
  # before_action :authorize
  
  def index
    unauthorized and return unless Auth.check('Manufacturing/Order/list', current_user)

    render json: {order: 100}
  end

  def order_list
  	 if not Auth.check('approval/approval_list', current_user)
    	unauthorized 
    	return
    end
  	order_all = Order.all
  	render json: {
  		orders: order_all
  	}
  end
end
