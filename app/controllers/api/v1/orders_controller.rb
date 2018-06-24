class Api::V1::OrdersController < Api::V1::BaseController
  before_action :authorize
  
  def index
    # unauthorized and return unless Auth.check('Manufacturing/Index/index', current_user)
    render json: {order: 100}
  end
end
