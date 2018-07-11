class Api::V1::AuthoritiesController < Api::V1::BaseController
  # before_action :authorize
  
  def index
    unauthorized and return unless Auth.check('Admin/Authority/list', current_user)

    render json: AuthRule.where(parent_id: 0).all
  end

  
end
