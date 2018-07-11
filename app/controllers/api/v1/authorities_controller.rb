class Api::V1::AuthoritiesController < Api::V1::BaseController
  before_action :authorize
  skip_before_action :authenticate_user, only: [:index]
  
  def index
    # unauthorized and return unless Auth.check('Manufacturing/Index/index', current_user)
    render json: AuthRule.where(parent_id: 0).all
  end
end
