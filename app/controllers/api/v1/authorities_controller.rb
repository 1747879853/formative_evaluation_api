class Api::V1::AuthoritiesController < Api::V1::BaseController
  # before_action :authorize
  
  def get_rulelist
    # unauthorized and return unless Auth.check('Admin/Authority/list', current_user)

    render json: AuthRule.where(parent_id: 0).all
  end

  def post_rulelist

    begin
      authrule = AuthRule.new(authrule_params)
      if authrule.save!
        render json: authrule
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_rulelist

    begin
      authrule = AuthRule.find(params.require(:params)[:id])
      if authrule.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_rulelist

    begin
      authrule = AuthRule.find(params.require(:params)[:id])
      if authrule.update(params.require(:params).permit(:name, :title, :status, :condition))
        render json: authrule
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def get_grouplist
    # unauthorized and return unless Auth.check('Admin/Authority/list', current_user)

    render  json:{'a': AuthGroup.where(status: 1).all ,'b': AuthRule.where(parent_id: 0).all}
  end
  
  private
  
  # Setting up strict parameters for when we add account creation.
  def authrule_params
    params.require(:params).permit(:name, :title, :status, :condition, :parent_id)
  end 

end
