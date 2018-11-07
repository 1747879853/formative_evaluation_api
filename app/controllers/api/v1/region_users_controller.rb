class Api::V1::RegionUsersController < Api::V1::BaseController
  def get_region_userlist    
    unauthorized and return unless Auth.check('region-manage/region-user', current_user)
    render json: RegionUser.where(region_id: params.require(:id)).all
  end

  def post_region_userlist
  	unauthorized and return unless Auth.check('region-manage/region-user', current_user)
  	arr = params.require(:params)[:userList]
  	region_id = params.require(:params)[:region_id]
  	RegionUser.where(region_id: region_id).all.destroy_all
  	arr.each do |i|
  		RegionUser.find_or_create_by(user_id: i,region_id: region_id)
  	end
    render json: RegionUser.where(region_id: region_id).all.size
  end
end
