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
  		  wst.user_id = 1
  		  wst.record_time = Time.now
  		  if not wst.save
  		  	msg ="分派失败！"
  		  end
  		end
  	end

    render json:{
    	msg: msg
    }
  end


  def work_shop_order_list 
  	work_shop_order_list = WorkOrder.joins(work_shop_tasks: [work_shop: :user]).where("work_shops.user_id=?",params[:user_id]).select("work_orders.id as work_order_id,work_orders.title,work_orders.maker,work_orders.template_type,work_shops.name,work_shops.id as work_shop_id,users.username,users.id as user_id,work_orders.number ")

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
  	p materials_id
  	msg = "分派到班组成功！"
  	ActiveRecord::Base.transaction do
	  	materials_id.each do |e|
	  		wtt = WorkTeamTask.new
	  		wtt.work_team_id = params[:work_team_id]
	  		wtt.material_id = e
	  		wtt.user_id = params[:user_id]
	  		wtt.record_time = Time.now
	  		wtt.number = params[:number]
	  		wtt.status = 0
	  		if not wtt.save
	  			msg = "分派到班组失败！"
	  		end

	  	end
    end

    render json: {
    	msg: msg
    }

  end

end
