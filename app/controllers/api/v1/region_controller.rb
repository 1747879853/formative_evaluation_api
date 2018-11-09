class Api::V1::RegionController < Api::V1::BaseController
  def region_list    
    unauthorized and return unless Auth.check('region-manage/region', current_user)
    render json: Region.where(parent_id: 0).all
  end
  
  def save_region
    unauthorized and return unless Auth.check('region-manage/region', current_user)
    r = Region.new
    r.title = params.require(:params)[:title]
    r.save!
    render json: r
  end

  def save_subregion
    unauthorized and return unless Auth.check('region-manage/region', current_user)
    r = Region.new
    r.title = params.require(:params)[:title]
    r.parent_id = params.require(:params)[:parent_id]
    r.save!
    render json: r
  end

  def delete_region
    unauthorized and return unless Auth.check('region-manage/region', current_user)
    begin
      r = Region.find(params.require(:params)[:id])
      if r 
        # ?????????????should delete all the associated users and oils
        Region.where(parent_id: params.require(:params)[:id]).all.destroy_all
        r.destroy
      end
      render json: { }
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_region
    unauthorized and return unless Auth.check('region-manage/region', current_user)
    begin
      r = Region.find(params.require(:params)[:id])

      r.title = params.require(:params)[:title]
      r.save!
      render json: r
    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
