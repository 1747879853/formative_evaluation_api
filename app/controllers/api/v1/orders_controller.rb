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
  		  wst.user_id = e
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

end
