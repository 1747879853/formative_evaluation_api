class Api::V1::SummaryController < Api::V1::BaseController
  def get_summary
    # unauthorized and return unless Auth.check('Admin/Authority/list', current_user)
    last = Summaries.last()
    if last.date.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
      render json: {
        date:last.date,
        address:last.address,
        workcontent:last.workcontent,
        transport:last.transport,
        explain:last.explain,
        costdata:Costdata.where(:summaries_id => last.id)
      }      
    end
  end

  def post_summary
  	begin
  		summary = Summaries.new(worklist_params)
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




 private
  def worklist_params
  	params.require(:params).permit(:date,:address,:workcontent,:transport,:explain)
  end

end
