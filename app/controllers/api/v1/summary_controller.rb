class Api::V1::SummaryController < Api::V1::BaseController
  # return one summary by user_id and current date
  def get_summary
    unauthorized and return unless Auth.check('daily_summary/get_summary', current_user)
    # last = Summary.where(:user_id => current_user.id)
    # last.each do |l|
    # if last.date.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
      # if l.try(:date).try(:strftime,"%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
    summary = Summary.where("user_id=? and date=?",current_user.id,Time.now.strftime("%Y-%m-%d")).last
    if summary.nil?
      render json:{
        "flag":0
      }   
    else
      render json: {
        "flag": 1,
        "date": summary.date,
        "address": summary.address,
       "workcontent": summary.workcontent,
        "transport": summary.transport,
        "explain": summary.explain,
        "costdata": Costdata.where(:summary_id => summary.id)
      }         
    end
  end
  
  def get_summary_by_id
    unauthorized and return unless Auth.check('daily_summary/query_summarries', current_user)
    render json: { summary: Summary.find_by_id(params.require(:id)),costdata: Costdata.where({summary_id: params.require(:id)}).all.select("name,thing,money")}
  end

  # def get_summaries_total
  #   begin
  #     sql = ActiveRecord::Base.connection()
  #     if params.require(:userid).to_i() == -1
  #       # "select count(*) from (select temp.id as money from (select summaries.id from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '2018-08-01' and '2018-09-15') as temp GROUP BY temp.id) as foo"
  #       summaries = sql.select_all "select count(*) from (select temp.id as money from (select summaries.id from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"') as temp GROUP BY temp.id) as foo"
  #     else
  #       summaries = sql.select_all "select count(*) from (select temp.id from (select summaries.id from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where users.id = "+ params.require(:userid) +" and summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"') as temp GROUP BY temp.id)as foo"
  #     end
  #     render json: {total: summaries}
  #   rescue Exception => e
  #     render json: { msg: e }, status: 500
  #   end
  # end
  
  def get_summaries
    unauthorized and return unless Auth.check('daily_summary/query_summarries', current_user)
    begin
      limit = params.require(:limit)
      offset = params.require(:offset)
      # Summary.where({user_id: 2,date: '2018-08-31'..'2018-09-06'}).all.select("id,date,workcontent")
      # summaries = Summary.where({user_id: params.require(:userid),date: params.require(:date)[0]..params.require(:date)[1]}).all
      sql = ActiveRecord::Base.connection()
      if params.require(:userid).to_i() == -1
        total = sql.select_value "select count(*) from summaries where summaries.date between '"+params.require(:date)[0].to_s()+"' and '"+params.require(:date)[1].to_s()+"'"
        summaries = sql.select_all "select temp.id,temp.username as name,temp.date,temp.workcontent,SUM(temp.money) as money from (select summaries.id,users.username,summaries.date,summaries.workcontent,costdata.money from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"') as temp GROUP BY temp.date,temp.username,temp.workcontent,temp.id limit "+limit.to_s()+" offset "+offset.to_s()
      else
        total = sql.select_value "select count(*) from summaries inner join users on users.id = summaries.user_id where users.id = "+params.require(:userid).to_s()+" and summaries.date between '"+params.require(:date)[0].to_s()+"' and '"+params.require(:date)[1].to_s()+"'"
        summaries = sql.select_all "select temp.id,temp.username as name,temp.date,temp.workcontent,SUM(temp.money) as money from (select summaries.id,users.username,summaries.date,summaries.workcontent,costdata.money from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where users.id = "+ params.require(:userid) +" and summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"') as temp GROUP BY temp.date,temp.username,temp.workcontent,temp.id limit "+limit.to_s()+" offset "+offset.to_s()
      end
      if summaries.length > 0
        render json: {total: total,summaries: summaries.as_json}
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end    
  end

  # get_summaries_s just different from get_summaries by date
  def get_summaries_s
    unauthorized and return unless Auth.check('daily_summary/query_summarries', current_user)
    begin
      @date  = 1.month
      limit = params.require(:limit)
      offset = params.require(:offset)
      if params.require(:date).to_i() == 1 
        @date = 1.month
      elsif params.require(:date).to_i() == 3
        @date = 3.month
      elsif params.require(:date).to_i() == 6
        @date = 6.month
      else
        @date = 7.day          
      end 
      # Summary.where({user_id: 2,date: '2018-08-31'..'2018-09-06'}).all.select("id,date,workcontent")
      # summaries = Summary.where({user_id: params.require(:userid),date: params.require(:date)[0]..params.require(:date)[1]}).all
      sql = ActiveRecord::Base.connection()
      if params.require(:userid).to_i() == -1
        total = sql.select_value "select count(*) from summaries where summaries.date between '"+(Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d")+"'"
        summaries = sql.select_all "select temp.id,temp.username as name,temp.date,temp.workcontent,SUM(temp.money) as money from (select summaries.id,users.username,summaries.date,summaries.workcontent,costdata.money from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+ (Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d") +"') as temp GROUP BY temp.date,temp.username,temp.workcontent,temp.id limit "+limit.to_s()+" offset "+offset.to_s()
      else
        total = sql.select_value "select count(*) from summaries inner join users on users.id = summaries.user_id where users.id = "+params.require(:userid).to_s()+" and summaries.date between '"+(Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d")+"'"
        summaries = sql.select_all "select temp.id,temp.username as name,temp.date,temp.workcontent,SUM(temp.money) as money from (select summaries.id,users.username,summaries.date,summaries.workcontent,costdata.money from summaries inner join costdata on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where users.id = "+ params.require(:userid) +" and summaries.date between '"+ (Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d") +"') as temp GROUP BY temp.date,temp.username,temp.workcontent,temp.id limit "+limit.to_s()+" offset "+offset.to_s()       
      end      
      if summaries.length > 0
        render json: {total: total,summaries: summaries.as_json}
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end    
  end

  # add summary
  def post_summary
    unauthorized and return unless Auth.check('daily_summary/post_summary', current_user)
    # user = User.find(current_user.id)
  	begin
      summary = Summary.new
      summary.date = params.require(:params)[:date]
      summary.address = params.require(:params)[:address]      
      summary.workcontent = params.require(:params)[:workcontent]
      summary.transport = params.require(:params)[:transport]
      summary.explain = params.require(:params)[:explain]
      summary.user_id = current_user.id
      summary.save!

      nodes = params.require(:params)[:costdata]
      if nodes.length > 0
        nodes.each do |value|
          pn = Costdata.new
          pn.name = value[:name]
          pn.thing = value[:thing]
          pn.money = value[:money]
          pn.summary_id = summary.id
          pn.save!
        end
      end
  	rescue Exception => e
      render json: { msg: e }, status: 500
    end   
  end

  def delete_summary
    unauthorized and return unless Auth.check('daily_summary/delete_summary', current_user)
    # user = User.find(current_user.id)
    begin
      cost = Summary.find(params.require(:params)[:id])
      if cost.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end






 # private
 #  def worklist_params
 #  	params.require(:params).permit(:date,:address,:workcontent,:transport,:explain)
 #  end

end
