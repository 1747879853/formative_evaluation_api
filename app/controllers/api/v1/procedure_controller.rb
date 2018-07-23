class Api::V1::ProcedureController < Api::V1::BaseController
  # before_action :authorize
  
  def procedure_nodes
    # unauthorized and return unless 
    if not Auth.check('procedure/procedure_nodes', current_user)
    	unauthorized 
    	return
    end
    prec = Procedure.where(approval_id: params[:approval_id]).where(status: 1)
    if prec.length > 0
    	render json: prec.first.procedure_nodes.order(:sequence)
    else
    	render json: []
    end

  end

  def procedure_create
  	if not Auth.check('procedure/procedure_create', current_user)
    	unauthorized 
    	return
    end

	begin
		tn = Time.now

		old_proc_arr = Procedure.where(status: 1).where(approval_id: params[:approval_id])
		if old_proc_arr.length >0 
			old_proc = old_proc_arr.first
			old_proc.status = 0
			old_proc.stoped_time = tn
			old_proc.save!
		end

		new_proc = Procedure.new
		new_proc.approval_id = params[:approval_id]
		new_proc.status = 1
		new_proc.created_time = tn
		new_proc.stoped_time = nil
		new_proc.save!



	    nodes = params[:proc_nodes]
		if nodes.length > 0
			nodes.each do |value|
				pn = ProcedureNode.new
				pn.name = value[:name]
				pn.owner_type = 'AuthGroup'
				pn.owner_id = value[:owner_id]
				pn.sequence = value[:sequence]
				pn.procedure_id = new_proc.id
				pn.save!
			end
		end

		render json:{msg: '保存成功',code: 1}
	rescue Exception => e
		render json:{msg: '保存失败',code: 0}
	end  	
  end

end
