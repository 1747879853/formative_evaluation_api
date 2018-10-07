class Api::V1::JobItemContentController < Api::V1::BaseController
  # before_action :authorize


  
  def get_jic_list
    unauthorized and return unless Auth.check('daily-summary/get_jic_list', current_user)
    # costs = AuthGroup.where(status: 1).all
    # JobItemContent.where(parent_id: 0)
    ags = AuthGroup.joins("LEFT JOIN job_item_contents ON auth_groups.id = job_item_contents.auth_group_id").where(status: 1).order("job_item_contents.created_at").select("auth_groups.id, auth_groups.title,job_item_contents.id as jic_id, job_item_contents.item_title as item_title, job_item_contents.item_weight as item_weight, job_item_contents.item_stds as item_stds, job_item_contents.item_cnts as item_cnts")
    agsarr = []
    ags.each do |e|
      agsarr << {id: e.id, title: e.title, jic_id: e.jic_id, item_title: e.item_title,item_weight: e.item_weight,item_stds: e.item_stds, item_cnts:  e.item_cnts}
    end

    render json:{
      jic_list: agsarr
    }
  end

  def get_current_user_jic
    ag = current_user.auth_groups.first
    if ag
      ret = ag.job_item_contents
    else 
      ret = []
    end
      render json:{
        code: 1,
        jics: ret
      }
    
  end

  def post_jic_list
    unauthorized and return unless Auth.check('daily-summary/post_jic_list', current_user)
  	begin
      if jic_params["jic_id"] == 0
        cost = JobItemContent.new(jic_params)
      else
        cost = JobItemContent.find_by(id: jic_params["jic_id"])
        cost.item_title = jic_params["item_title"]
        cost.item_weight = jic_params["item_weight"]
        cost.item_stds = jic_params["item_stds"]
        cost.item_cnts = jic_params["item_cnts"]

      end
      if cost.save!
        render json: cost
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end



  def delete_jic_list
    unauthorized and return unless Auth.check('daily-summary/delete_jic_list', current_user)

    begin
      cost = JobItemContent.find(params.require(:params)[:jic_id])
      if cost.delete
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_jic_list
    unauthorized and return unless Auth.check('daily-summary/patch_jic_list', current_user)

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

  def jic_params
    params.require(:params).permit(:auth_group_id,:jic_id,:item_title,:item_weight,:item_stds,:item_cnts)
  end

end

