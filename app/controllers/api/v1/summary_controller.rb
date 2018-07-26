class Api::V1::SummaryController < Api::V1::BaseController
  def get_summary
    # unauthorized and return unless Auth.check('Admin/Authority/list', current_user)
    last = Summary.where(:users_id => current_user.id)
    # if last.date.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
    if last.try(:date).try(:strftime,"%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
      render json: {
        date:last.date,
        address:last.address,
        workcontent:last.workcontent,
        transport:last.transport,
        explain:last.explain,
        costdata:Costdata.where(:summaries_id => last.id)
      }
    else
      render json:{}      
    end
  end

  def post_summary
  	begin
      summary = Summary.new
      summary.date = params.require(:params)[:date]
      summary.address = params.require(:params)[:address]      
      summary.workcontent = params.require(:params)[:workcontent]
      summary.transport = params.require(:params)[:transport]
      summary.explain = params.require(:params)[:explain]
      summary.uid = current_user.id
      puts "----------------"
      puts current_user.id
      puts params.require(:params)[:date]
      puts params.require(:params)[:address]      
      puts params.require(:params)[:workcontent]
      puts params.require(:params)[:transport]
      puts params.require(:params)[:explain]

      # summary.uid = 11
      summary.save!

      nodes = params.require(:params)[:costdata]
      if nodes.length > 0
        nodes.each do |value|
          pn = Costdata.new
          pn.name = value[:name]
          pn.thing = value[:thing]
          pn.money = value[:money]
          pn.summaries_id = summary.id
          pn.save!
        end
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
