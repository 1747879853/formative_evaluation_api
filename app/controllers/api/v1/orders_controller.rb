class Api::V1::OrdersController < Api::V1::BaseController
  # before_action :authorize
  
  def index
    unauthorized and return unless Auth.check('Manufacturing/Order/list', current_user)

    render json: {order: 100}
  end

  def order_list
  	 if not Auth.check('approval/approval_list', current_user)
    	unauthorized 
    	return
    end
  	order_all = Order.all
  	render json: {
  		orders: order_all
  	}
  end

  def post_order
    order = Order.new
    order.no = params.require(:params)[:no]
    order.client_title = params.require(:params)[:client_title]
    order.record_time = Time.now
    order.title = ""
    if order.save!
      render json: {
        order: order
      }
    end
  end

  def order_details

  	order = Order.find_by_id(params[:order_id])
  	work_orders = order.work_orders
  	render json: {
  		work_orders: work_orders
  	}

  end

  def work_order_details

 		work_order_id = params[:work_order_id]
 		materials_boms = []
 		
 		materials = Material.where(work_order_id: work_order_id)
 		materials.each_with_index do |e,i|
 			material = {}
 			material[:name] = e.name
 			material[:graph_no] = e.graph_no.split(',')
 			material[:number] = e.number
 			material[:comment] = e.comment
 			material[:children] = Bom.where(material_id: e.id)
 			material_arr = []
 			material_arr << material
 			materials_boms << material_arr
 		end
 		render json:{
 			materials_boms: materials_boms
 		}

  end
  
  def xialiao
  	xialiao = WorkShop.where(dept_type: '下料')

  	render json:{
  		manager: xialiao
  	}
  end


  def zupin
  	zupin = WorkShop.where(dept_type: '组拼')
  	render json:{
  		manager: zupin
  	}
  end

  def work_shop_task_add
  	# p params
  	# p params[:xialiao]
  	# p params[:zupin]
  	# p params[:work_order_id]
  	# wst = WorkShopTask.new
  	# 	wst.work_shop_id = WorkShop.find_by_user_id(params[:zupin]).id
  	# 	wst.work_order_id = params[:work_order_id]
  	# 	wst.user_id = params[:zupin]
  	# 	wst.record_time = Time.now
  	# 	wst.save

  	arr =[]

  	if params[:xialiao]!=""
  	  arr << params[:xialiao]
  	end

  	if params[:zupin]!=""
  		arr << params[:zupin]
  	end
  	msg = "分派成功！"
  	ActiveRecord::Base.transaction do
  		arr.each do |e|
  			wst = WorkShopTask.new
  		  wst.work_shop_id = WorkShop.find_by_user_id(e).id
  		  wst.work_order_id = params[:work_order_id]
  		  wst.user_id = current_user.id
  		  wst.record_time = Time.now


  		  if not wst.save
  		  	msg ="分派失败！"
        else
          wst.work_logs.create(work_order_id:params[:work_order_id],record_time:Time.now,description: User.find_by_id(wst.user_id).username+"分配工单:"+ params[:work_order_id].to_s+" 到"+  WorkShop.find_by_user_id(e).name+"车间") 
  		  end
  		end
  	end

    render json:{
    	msg: msg
    }
  end


  def work_shop_order_list 
  	work_shop_order_list = WorkOrder.joins(work_shop_tasks: [work_shop: :user]).where("work_shops.user_id=?",current_user.id).select("work_orders.id as work_order_id,work_orders.title,work_orders.maker,work_orders.template_type,work_shops.name,work_shops.id as work_shop_id,users.username,users.id as user_id,work_orders.number ")

  	# work_shop_order_list = WorkOrder.joins(work_shop_tasks: [work_shop: :user]).select("work_orders.id as work_order_id,work_orders.title,work_orders.maker,work_orders.template_type,work_shops.name,work_shops.id as work_shop_id,users.username,users.id as user_id,work_orders.number ")
  	# data = []
  	# work_shop_order_list.each do |e|
  	# 	list = []
  	# 	list << e
  	# 	data<<list
  	# end
  
  	render json: {
  	 data: work_shop_order_list
  	 }
  end

  def work_teams

  	teams = WorkTeam.where(work_shop_id: params[:work_shop_id])
  	render json:{
  		teams: teams
  	}

  end


  def work_team_task_add

  	wo = WorkOrder.find(params[:work_order_id])
  	materials_id = wo.materials.pluck(:id)
  	# p materials_id
  	msg = "分派到班组成功！"
  	ActiveRecord::Base.transaction do
	  	materials_id.each do |e|
	  		wtt = WorkTeamTask.new
	  		wtt.work_team_id = params[:work_team_id]
	  		wtt.material_id = e
	  		wtt.user_id = current_user.id
	  		wtt.record_time = Time.now
	  		wtt.number = params[:number]
	  		wtt.status = 0
	  		if not wtt.save
	  			msg = "分派到班组失败！"
        else
          wtt.work_logs.create(work_order_id:params[:work_order_id],record_time: Time.now,description: User.find_by_id(current_user.id).username+"分派"+Material.find_by_id(e).name+"到:"+WorkTeam.find_by_id( params[:work_team_id]).name+";数量："+params[:number].to_s)
	  		end

	  	end
    end

    render json: {
    	msg: msg
    }

  end

  def work_team_task_list
  	wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_teams.user_id=?",current_user.id).select("work_team_tasks.id as id,materials.id as mid,materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc")
  	render json:{
  		data: wtt
  	}
  end

  def team_task_boms
  	mid = params[:material_id]
  	task_id = params[:task_id]
  	team_task_boms = Bom.joins(material: :work_team_tasks).where("materials.id=? and work_team_tasks.id=? ",mid,task_id).select("boms.id as bom_id,boms.name,materials.name as m_name,work_team_tasks.number,boms.number*work_team_tasks.number as qty, boms.spec,boms.length,boms.width,boms.comment")
   	render json:{
   		boms: team_task_boms
   	}
  end


  def team_task_material_finished

  	finished_num = params[:finish_number]
  	team_task_id = params[:team_task_id]

  	wtt = WorkTeamTask.find_by(id: team_task_id)
  	wtt.finished_number =(wtt.finished_number ? wtt.finished_number : 0)+finished_num

  	wttd = WorkTeamTaskDetail.new
  	wttd.work_team_task_id = team_task_id
  	wttd.finished_number = finished_num
  	wttd.user_id = current_user.id    #需替换成正式人员
  	wttd.record_time = Time.now
	  
	  if wtt.save&&wttd.save
	  	
	  	msg = "提交成功"
	  else
	  	msg = "保存失败"
	  end
	
  	render json:{
  		msg: msg
  	}
  end

  def team_task_material_passed
  	
  	passed_num = params[:pass_number]
  	team_task_id = params[:team_task_id]

  	wtt = WorkTeamTask.find_by(id: team_task_id)
  	wtt.passed_number =(wtt.passed_number ? wtt.passed_number : 0)+passed_num

  	wttd = WorkTeamTaskDetail.new
  	wttd.work_team_task_id = team_task_id
  	wttd.passed_number = passed_num
  	wttd.user_id = current_user.id    #需替换成正式人员
  	wttd.record_time = Time.now
	  
	  if wtt.save&&wttd.save
	  	
	  	msg = "提交成功"
	  else
	  	msg = "保存失败"
	  end
	
  	render json:{
  		msg: msg
  	}
  end


  def boms_approval
  	p params
  	msg ="领料成功"
  	ActiveRecord::Base.transaction do
	  	ba = BomsApproval.new
	  	ba.work_team_task_id = params[:team_task_id]
	  	ba.status = 1
	  	ba.user_id = current_user.id
	  	ba.approval_owner_id = WorkTeamTask.find_by_id(params[:team_task_id]).user_id
	  	ba.apply_comment =params[:comment]
	  	ba.record_time = Time.now
	  	if not ba.save
	  		msg = "保存失败"
	  	end
	  	params[:boms].each do |e|
	  		bad = BomsApprovalDetail.new
	  		bad.boms_approval_id = ba.id
	  		bad.bom_id = e["bom_id"]
	  		bad.approval_number = e["req_qty"]
	  		if not bad.save
	  			msg = "保存失败"
	  		end
	  	end
	  	
	   

  	end

  	render json:{
  		msg: msg
  		}
  		
  end

  def boms_approval_list

  	if params[:approval] == "1"
  		ba = BomsApproval.where(approval_owner_id: current_user.id,status: 1)
    elsif params[:approval] == "23"
      ba = BomsApproval.where(approval_owner_id: current_user.id,status: [2,3])
  	else
  		ba = BomsApproval.where(work_team_task_id: params[:team_task_id])
    end
  	render json:{
  		boms_approval_list: ba
  	}
  end

  def boms_approval_detail

  	boms_approval_detail = Bom.joins(boms_approval_details: :boms_approval).where("boms_approval_details.boms_approval_id=?",params[:approval_id]).select("boms.*,boms_approval_details.approval_number as req_qty")
  	
  	render json:{
  		boms_approval_detail: boms_approval_detail
  	}
  end

  def auditing_boms

    id = params[:id]
    status = params[:status]
    approval_comment = params[:approval_comment]
    ba = BomsApproval.find_by_id(id)

    ba.status = status
    ba.approval_comment = approval_comment ? approval_comment : ""
    if ba.save
      msg = "审核成功"
    else
      msg = "审核失败"
    end
    
    render json:{
      msg: msg
    }
  end


  def order_process

    worklogs = WorkLog.where(work_order_id:Order.joins(:work_orders).where("orders.id =?",params[:id]).select("work_orders.id")).order("work_order_id,record_time")
    
    render json:{
      worklogs: worklogs
    }
  end

  def team_task_finish
    wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_team_tasks.id= ?",params[:id]).select("work_team_tasks.id as id,materials.id as mid,materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc")
    wttd = WorkTeamTaskDetail.where(work_team_task_id:params[:id])
    render json:{
      data: wtt,
      wttd: wttd
    }
  end

  def get_work_shop
    
    render json: WorkShop.joins(:user).select("work_shops.id, name, dept_type, user_id, username").where(status: 1).all
  end

  def post_work_shop

    begin
      workshop = WorkShop.new(params.require(:params).permit(:name, :dept_type, :status, :user_id))
      if workshop.save!
        render json: workshop
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_work_shop

    begin
      workshop = WorkShop.find(params.require(:params)[:id])
      if workshop.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_work_shop

    begin
      workshop = WorkShop.find(params.require(:params)[:id])
      if workshop.update(params.require(:params).permit(:name, :dept_type, :user_id))
        render json: workshop
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def get_work_team
    
    render json: WorkTeam.joins(:work_shop).joins(:user).select("work_teams.id, work_teams.name, work_shop_id, work_shops.name as work_shop_name, work_teams.user_id, username").where(status: 1).all
  end
  
  def post_work_team

    begin
      workteam = WorkTeam.new(params.require(:params).permit(:name, :work_shop_id, :status, :user_id))
      if workteam.save!
        render json: workteam
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_work_team

    begin
      workteam = WorkTeam.find(params.require(:params)[:id])
      if workteam.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def patch_work_team
    begin
      workteam = WorkTeam.find(params.require(:params)[:id])
      if workteam.update(params.require(:params).permit(:name, :work_shop_id, :user_id))
        render json: workteam
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
