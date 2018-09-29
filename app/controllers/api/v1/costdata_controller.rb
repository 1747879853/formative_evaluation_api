class Api::V1::CostdataController < Api::V1::BaseController
	def costdata_query
		unauthorized and return unless Auth.check('daily_summary/query_summarries', current_user)
	    begin
	      limit = params.require(:limit)
	      offset = params.require(:offset)
	      sql = ActiveRecord::Base.connection()
	      if params.require(:userid).to_i() == 0
	        total = sql.select_value "select count(*) from costdata inner join summaries on costdata.summary_id = summaries.id where summaries.date between '"+params.require(:date)[0].to_s()+"' and '"+params.require(:date)[1].to_s()+"'"
	        costdatas = sql.select_all "select summaries.date,users.username,costdata.names,costdata.thing,costdata.money from costdata inner join summaries on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"' limit "+limit.to_s()+" offset "+offset.to_s()
	      else
	        total = sql.select_value "select count(*) from costdata inner join summaries on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+params.require(:date)[0].to_s()+"' and '"+params.require(:date)[1].to_s()+"' and users.id = "+params.require(:userid)
	        costdatas = sql.select_all "select summaries.date,users.username,costdata.names,costdata.thing,costdata.money from costdata inner join summaries on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where users.id = "+ params.require(:userid) +" and summaries.date between '"+ params.require(:date)[0].to_s() +"' and '"+ params.require(:date)[1].to_s() +"' limit "+limit.to_s()+" offset "+offset.to_s()
	      end
	      if costdatas.length > 0
	        render json: {total: total,costdatas: costdatas.as_json}
	      end
	    rescue Exception => e
	      render json: { msg: e }, status: 500
	    end 
	end

	def costdata_query_s
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
	      limit = params.require(:limit)
	      offset = params.require(:offset)
	      sql = ActiveRecord::Base.connection()
	      # puts "-------------------------------"
	      if params.require(:userid).to_i() == 0
	        total = sql.select_value "select count(*) from costdata inner join summaries on costdata.summary_id = summaries.id where summaries.date between '"+(Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d")+"'"
	        costdatas = sql.select_all "select summaries.date,users.username,costdata.names,costdata.thing,costdata.money from costdata inner join summaries on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+ (Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d") +"' limit "+limit.to_s()+" offset "+offset.to_s()
	      else
	        total = sql.select_value "select count(*) from costdata inner join summaries on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where summaries.date between '"+(Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d")+"' and users.id = "+params.require(:userid)
	        costdatas = sql.select_all "select summaries.date,users.username,costdata.names,costdata.thing,costdata.money from costdata inner join summaries on costdata.summary_id = summaries.id inner join users on users.id = summaries.user_id where users.id = "+ params.require(:userid) +" and summaries.date between '"+ (Time.now - @date).strftime("%Y-%m-%d") +"' and '"+ Time.now.strftime("%Y-%m-%d") +"' limit "+limit.to_s()+" offset "+offset.to_s()
	      end
	      if costdatas.length > 0
	        render json: {total: total,costdatas: costdatas.as_json}
	      end
	    rescue Exception => e
	      render json: { msg: e }, status: 500
	    end 
	end
end