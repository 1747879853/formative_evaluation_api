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
  
  def post_grouplist

    begin
      authgroup = AuthGroup.new(authgroup_params)
      if authgroup.save!
        render json: authgroup
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_grouplist

    begin
      authgroup = AuthGroup.find(params.require(:params)[:id])
      if authgroup.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_grouplist

    begin
      authgroup = AuthGroup.find(params.require(:params)[:group_id])
      authgroup.auth_rules.destroy_all
      a = params.require(:params)[:id]
      authgroup.auth_rules.push AuthRule.where(id: a).all
      render json: authgroup
    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def get_userlist
    # unauthorized and return unless Auth.check('Admin/Authority/list', current_user)

    render  json:{'a': User.all ,'b': AuthGroup.where(status: 1).all}
  end

  def patch_userlist

    begin
      authuser = User.find(params.require(:params)[:user_id])
      authuser.auth_groups.destroy_all
      a = params.require(:params)[:id]
      authuser.auth_groups.push AuthGroup.where(id: a).all
      render json: authuser
    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  private
  
  # Setting up strict parameters for when we add account creation.
  def authrule_params
    params.require(:params).permit(:name, :title, :status, :condition, :parent_id)
  end 

  def authgroup_params
    params.require(:params).permit(:title)
  end

end
