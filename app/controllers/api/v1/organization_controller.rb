class Api::V1::OrganizationController < Api::V1::BaseController

  def get_organization
    render json: Organization.where(parent_id: 0).all
  end

  def post_organization
    begin
      organization = Organization.new(params.require(:params).permit(:name,:parent_id))
      if organization.save!
        render json: organization
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_organization

    begin
      organization = Organization.find(params.require(:params)[:id])
      if organization.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_organization

    begin
      organization = Organization.find(params.require(:params)[:id])
      if organization.update(params.require(:params).permit(:name))
        render json: organization
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def get_organization_user
    render json:{'a': OrganizationsUser.all ,'b': User.select("id,username").where(status: 1).all}
  end

  def post_organization_user
    begin
      organizationsuser = OrganizationsUser.new(params.require(:params).permit(:organization_id,:user_id,:leader))
      if organizationsuser.save!
        render json: organizationsuser
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_organization_user

    begin
      organizationuser = OrganizationsUser.find(params.require(:params)[:id])
      if organizationuser.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end
end