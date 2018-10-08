class Api::V1::SummaryEvaluationController < Api::V1::BaseController
    
  def get_summaries_scores
    unauthorized and return unless Auth.check('daily_summary/get_summaries_scores', current_user)
    begin
      limit = params.require(:limit)
      offset = params.require(:offset)
     
      sql = ActiveRecord::Base.connection()
      # query summaries of current_user's all subornate users 
      if params.require(:userid).to_i() == 0
        # ????????????????here need modify in the future
        
        # user_arr = current_user.subordinates.map(&:id)
        

        # total = Summary.where(user_id: user_arr).where(date: params.require(:date)[0]..params.require(:date)[1]).count

        total = sql.select_value "select count(*) from summaries where summaries.date between '"+params.require(:date)[0].to_s()+"' and '"+params.require(:date)[1].to_s()+"'"

        summaries = sql.select_all "select temp.id,temp.username as name,temp.date,temp.workcontent,SUM(temp.money) as money from (select summaries.id,users.username,summaries.date,summaries.workcontent,costdata.money from summaries left join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"') as temp GROUP BY temp.date,temp.username,temp.workcontent,temp.id limit "+limit.to_s()+" offset "+offset.to_s()
      else
        total = sql.select_value "select count(*) from summaries inner join users on users.id = summaries.user_id where users.id = "+params.require(:userid).to_s()+" and summaries.date between '"+params.require(:date)[0].to_s()+"' and '"+params.require(:date)[1].to_s()+"'"

        summaries = sql.select_all "select temp.id,temp.username as name,temp.date,temp.workcontent,SUM(temp.money) as money from (select summaries.id,users.username,summaries.date,summaries.workcontent,costdata.money from summaries left join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where users.id = "+ params.require(:userid) +" and summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"') as temp GROUP BY temp.date,temp.username,temp.workcontent,temp.id limit "+limit.to_s()+" offset "+offset.to_s()
      end
      
      summ_json = summaries.as_json
      
      summ_json_ids = summ_json.collect{|e| e["id"]}
      ss_arr = SummaryScore.where(summary_id: summ_json_ids).map(&:summary_id)
      summ_json.each do |ss|
        ss["workcontentformat"] = Summary.work_cnt_fmt(ss["workcontent"])
        ss["evaluated"] = ss_arr.include?(ss["id"]) 
        
      end

      render json: {total: total,summaries: summ_json}
    rescue Exception => e
      render json: { msg: e }, status: 500
    end 
  end
  def get_evaluation_jics
    unauthorized and return unless Auth.check('daily-summary/get_evaluation_jics', current_user)
# {"workcnt"=>"19;内容1-质量:55,|", "userid"=>"11", "summaryid"=>"30"}
      ids_arr = []
      params.require(:workcnt).split('|').each do |item|
        ids_arr << item.split(';')[0].to_i
      end

      uid  = params.require(:userid) 
      sid = params.require(:summaryid)

      jics = JobItemContent.joins("left join summary_scores on summary_scores.job_item_content_id = job_item_contents.id and summary_scores.summary_id = #{sid} left join users on summary_scores.user_id = users.id ").where(id: ids_arr).select("job_item_contents.id,job_item_contents.auth_group_id,  job_item_contents.item_title, job_item_contents.item_weight, job_item_contents.item_stds, job_item_contents.item_cnts, summary_scores.id as summary_score_id, summary_scores.score_time, users.username, summary_scores.score, summary_scores.score_total")
      role_name = AuthGroup.find(jics.first.auth_group_id).title
      
      # agsarr = []
      # ags.each do |e|
      #   agsarr << {id: e.id, title: e.title, jic_id: e.jic_id, item_title: e.item_title,item_weight: e.item_weight,item_stds: e.item_stds, item_cnts:  e.item_cnts}
      # end


      render json: {
        jic_arr: jics,
        user_name: User.find(uid).username,
        role_name:  role_name,

      }
  end

  def save_evaluation
    unauthorized and return unless Auth.check('daily-summary/save_evaluation', current_user)
    ssd = params.require(:summaryscore)
    sid = params.require(:summaryid)
    
    tt = Time.now
    ssd.each do |ele|
      ele_json = JSON.parse(ele)
      ss = SummaryScore.new
      ss.summary_id = sid
      ss.score_time = tt
      ss.user_id = current_user.id
      ss.job_item_content_id = ele_json["id"]
      ss.score = ""
      ss.score_total = 0
      ele_json["item_stds_arr"].each do |ee|
        ss.score_total = ss.score_total + ee["proportion"].to_f*ee["score"].to_f
        ss.score =ss.score + ee["score"].to_s + ','
      end
      ss.score = ss.score.chop  #delete the last character
      ss.save!
    end

    render json: {}
  end

end
