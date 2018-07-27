class Api::V1::SummaryController < Api::V1::BaseController
  def get_summary
    # unauthorized and return unless Auth.check('Admin/Authority/list', current_user)
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
        "costdata": Costdata.where(:summary_id => summary.id).all.each
      }         
    end
  end

  def post_summary
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




 # private
 #  def worklist_params
 #  	params.require(:params).permit(:date,:address,:workcontent,:transport,:explain)
 #  end

end
