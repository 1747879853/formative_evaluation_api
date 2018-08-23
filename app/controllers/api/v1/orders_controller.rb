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

  def upload_work_order
    # {"file"=>#<ActionDispatch::Http::UploadedFile:0x00000005443ae0 @tempfile=#<Tempfile:/tmp/RackMultipart20180822-9479-8lm9n4.txt>, @original_filename="vue学习.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"file\"; filename=\"vue\xE5\xAD\xA6\xE4\xB9\xA0.txt\"\r\nContent-Type: text/plain\r\n">, "orderId"=>"1"}

    # order = Order.find_by_id(params[:orderId])
    xls = Roo::Spreadsheet.open(params[:file].path)
    ii = xls.sheet(0).first_row
    last_row_num = xls.sheet(0).last_row
    wo = nil
    mat = nil
    while ii <= last_row_num do
      row_arr = xls.sheet(0).row(ii)
      row_arr1 = row_arr.compact

      str1 = row_arr1[0] ? row_arr1[0].gsub(/[[:space:]]+/, "") : ""
      
      if str1 == "工程名称"
        row_arr2 = xls.sheet(0).row(ii+1).compact
        row_arr3 = xls.sheet(0).row(ii+2).compact
        row_arr4 = xls.sheet(0).row(ii+3).compact

        wo = WorkOrder.new
        wo.title = row_arr1[1]
        wo.template_type = row_arr2[1]
        wo.maker = row_arr3[1]
        wo.number = row_arr4[1]        
        wo.status = 1 #do not know how to set ????????
        wo.order_id = params[:orderId]
        wo.record_time = Time.now
        wo.save!
        ii = ii + 4
        next
      end
      
      if str1 == "图号"
        row_arr2 = xls.sheet(0).row(ii+1).compact
        row_arr3 = xls.sheet(0).row(ii+2).compact
        row_arr4 = xls.sheet(0).row(ii+3).compact

        mat = Material.new
        mat.graph_no = row_arr1[1]
        mat.name = row_arr2[1]
        mat.number = row_arr3[1]
        mat.comment = row_arr4[1]
        mat.work_order_id = wo.id
        mat.save!
        ii = ii + 4
        next
      end
      
      
      if str1 == "序号"
        jj = ii + 1
        bom_arr = xls.sheet(0).row(jj).compact
        while bom_arr.length > 0
          bom = Bom.new
          bom.name   =  bom_arr[1]
          bom.spec   =  bom_arr[2] +',' + bom_arr[3]
          bom.length    = bom_arr[4]
          bom.width     = bom_arr[5]
          bom.number =  bom_arr[6]
          bom.total  =  bom_arr[7]
          bom.comment   = bom_arr[8]
          bom.material_id = mat.id
          bom.save!
          jj = jj + 1
          bom_arr = xls.sheet(0).row(jj).compact
        end
        ii = jj + 1
        next
      end

      ii = ii + 1
    end
    render json:{
      code: 1,
      msg: "success",
      # data: ApprovalAdmin.all.order('status DESC,created_time')
    }

  end

  def order_details
  	order = Order.find_by_id(params[:order_id])
  	work_orders = order.work_orders
  	render json: {
  		work_orders: work_orders
  	}
  end

  def post_work_order
    work_order = WorkOrder.new
    work_order.number = params[:number]
    work_order.title = params[:title]
    work_order.template_type = params[:template_type]
    work_order.maker = params[:maker]
    work_order.status = 1
    work_order.order_id = params[:order_id]
    work_order.record_time = Time.now
    if work_order.save!
      render json:{
        work_order: work_order
      }
    end
  end

  def work_order_details

 		work_order_id = params[:work_order_id]
 		materials_boms = []
 		
 		materials = Material.where(work_order_id: work_order_id)
 		materials.each_with_index do |e,i|
 			material = {}
 			material[:name] = e.name
 			material[:graph_no] = e.graph_no ? e.graph_no.split(',') : ""
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

  def post_template
    begin
      material = Material.new(materials_params)
      if material.save!
        boms = params.require(:params)[:boms]
        if boms.length > 0
          boms.each do |value|
            pn = Bom.new
            pn.number =  value[:bom_number]    
            pn.total  =  value[:total]
            pn.name   =  value[:bom_name]
            pn.spec   =  value[:spec]
            pn.length    = value[:bom_length]
            pn.width     = value[:bom_width]
            pn.comment   = value[:bom_comment]
            pn.material_id = material.id
            pn.save! 
          end
        end
      end
      render json: {
        iscommit: 1
      }
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end
  
  def xialiao
  	xialiao = WorkShop.where(dept_type: '下料',status: 1)
  	render json:{
  		manager: xialiao
  	}
  end


  def zupin
  	zupin = WorkShop.where(dept_type: '组拼',status: 1)
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
          wst.work_logs.create(number: WorkOrder.find(params[:work_order_id]).number,get_user_id: e,user_id:current_user.id,work_order_id:params[:work_order_id],record_time:Time.now,description: User.find_by_id(wst.user_id).username+" 于 "+Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s+" 分派工单: "+ params[:work_order_id].to_s++" 到"+  WorkShop.find_by_user_id(e).name+" 车间") 
  		  end
  		end
  	end

    render json:{
    	msg: msg
    }
  end


  def work_shop_order_list 
  	work_shop_order_list = WorkOrder.joins(work_shop_tasks: [work_shop: :user]).where("work_shops.user_id=?",current_user.id).select("work_shop_tasks.id as wstid,work_orders.id as work_order_id,work_orders.title,work_orders.maker,work_orders.template_type,work_shops.name,work_shops.id as work_shop_id,users.username,users.id as user_id,work_orders.number ")

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

  	teams = WorkTeam.where(work_shop_id: params[:work_shop_id]).where(status: 1)
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
        wtt.work_shop_task_id = params[:wst_id]
	  		wtt.status = 0
	  		if not wtt.save
	  			msg = "分派到班组失败！"
        else
          wtt.work_logs.create(parent_id:wtt.work_shop_task_id,get_user_id: WorkTeam.find_by_id( params[:work_team_id]).user_id ,number:wtt.number,user_id:current_user.id,work_order_id:params[:work_order_id],record_time: Time.now,description: User.find_by_id(current_user.id).username+" 于 "+Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s+" 分派 "+Material.find_by_id(e).name+" 到: "+WorkTeam.find_by_id( params[:work_team_id]).name+" ;数量："+params[:number].to_s+" ;")
	  		end

	  	end
    end

    render json: {
    	msg: msg
    }

  end

  def work_team_task_list


    ws = WorkShop.find_by_dept_type("喷漆")
    wt = WorkTeam.where(work_shop_id:ws.id,user_id:current_user.id).first
      if wt
        wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_team_tasks.paint=1 and work_team_tasks.number- COALESCE(work_team_tasks.passed_number,0)=0 and work_team_tasks.paint_team = ?",wt.id).select("work_team_tasks.work_team_id,work_team_tasks.process,work_team_tasks.id as id,materials.id as mid,materials.work_order_id as wo_id, materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc")
        render json:{
        data: wtt,
        paint: true  
        }
      else
  	    wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_teams.user_id=? and work_team_tasks.status = 0",current_user.id).select("work_team_tasks.work_team_id,work_team_tasks.process,work_team_tasks.id as id,materials.id as mid,materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc")
  	    render json:{
  		  data: wtt
  	  }
      end
  end

  def team_task_boms

  	mid = params[:material_id] if params[:material_id]
    if params[:task_id]
  	   task_id = params[:task_id] 
  	   team_task_boms = Bom.joins(material: :work_team_tasks).where("materials.id=? and work_team_tasks.id=? ",mid,task_id).select("boms.id as bom_id,boms.name,materials.name as m_name,work_team_tasks.number,boms.number*work_team_tasks.number as qty, boms.spec,boms.length,boms.width,boms.comment")
   	else
       team_task_boms = Bom.joins(:material).where("materials.id=?  ",mid).select("boms.id as bom_id,boms.name,materials.name as m_name,materials.number,boms.number*materials.number as qty, boms.spec,boms.length,boms.width,boms.comment")

    end

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
    if wtt.passed_number > wtt.number
      render json:{
        msg: "合格数量不可大于分配数量"
      }else
    wl = WorkLog.where(owner_type:"WorkTeamTask").where(owner_id:team_task_id).first
    des = wl.description.split("|").count==1 ? wl.description.split("|") : wl.description.split("|")[0..-2]
  
    
    wl.description = des.join(",") + "| 已完成数量: "+wtt.passed_number.to_s+";  生产进度: " + helper.number_to_percentage(wtt.passed_number*100/wtt.number,precision: 2)
    wl.passed_number = wtt.passed_number
    wl.save
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

 def checking_list

    count  = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_team_tasks.status=2").count
    wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_team_tasks.status=2").select("work_team_tasks.work_team_id,work_team_tasks.process,work_team_tasks.id as id,materials.id as mid,materials.work_order_id as wo_id, materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc").page(params[:page]).per(3)
    
    render json:{
      count: count,
      data: wtt
      
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

    render json:{'a': WorkShop.joins(:user).select("work_shops.id, name, dept_type, user_id, username").where(status: 1).all ,'b': User.select("id,username").where(status: 1).all}
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

    render json:{'a': WorkTeam.joins(:work_shop).joins(:user).select("work_teams.id, work_teams.name, work_shop_id, work_shops.name as work_shop_name, work_teams.user_id, username").where(status: 1).all,'b': WorkShop.select("id, name,user_id").where(status: 1).all ,'c': User.select("id,username").where(status: 1).all}
  end
  
  def post_work_team

    begin
      workteam = WorkTeam.new(params.require(:params).permit(:name, :work_shop_id, :status, :user_id))
      if workteam.save!
        render json: WorkTeam.joins(:work_shop).joins(:user).select("work_teams.id, work_teams.name, work_shop_id, work_shops.name as work_shop_name, work_teams.user_id, username").where(id: workteam.id)

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
        render json: WorkTeam.joins(:work_shop).joins(:user).select("work_teams.id, work_teams.name, work_shop_id, work_shops.name as work_shop_name, work_teams.user_id, username").where(id: workteam.id)
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def work_logs
    wl = WorkLog.all

    render json:{
      work_logs: wl
    }
  end

  def work_log_tree
    str_where = "1=1"
    arr_where = []
    if params[:client_name] and params[:client_name]!=""
      str_where += " and title like ?"
      arr_where<< "%"+params[:client_name] +"%"
    end
    if  params[:type_name]and params[:type_name]!=""
      str_where += " and template_type like ?"
      arr_where<< "%"+params[:type_name] +"%"
    end
    if params[:w_order_id]and params[:w_order_id]!=""
      str_where += " and id = ? "
      arr_where<< params[:w_order_id]
    end

   
    if arr_where.length ==0
    order_ids = WorkOrder.select("order_id").distinct
    else
      order_ids = WorkOrder.where(str_where,*arr_where).select("order_id").distinct
    end
    arr = []
    order_ids.each do |e|
      h = {}
      order  = Order.find_by_id(e.order_id)
      h[:title] = order.client_title + "  订单号："+ order.no
      h[:expand] = true

      wl = WorkOrder.where(order_id:e.order_id).select("id as work_order_id,title,template_type,record_time").distinct
      h[:children] = []
      wl.each do|f|
        h1 = {}
        h1[:title] ="工单号:" +f.work_order_id.to_s+"  "+f.record_time.strftime('%Y-%m-%d').to_s+"日  "+f.title+"    " +f.template_type+"  "
        h1[:expand] = true
        wst = WorkLog.where(owner_type: "WorkShopTask",work_order_id: f.work_order_id)

        h1[:children] = []
        wst.each do|g|

          h2 = {}
          h2[:title] = g.description
          h2[:expand] = true
          h2[:children] = WorkLog.where(owner_type:"WorkTeamTask",parent_id: g.owner_id).select("*,description as title")
          h1[:children]<< h2
        end
         h[:children]<< h1
      end
      arr << h
    end






    # wl = WorkOrder.select("id as work_order_id,title,template_type,record_time").distinct
    # arr = []
    # wl.each do |e|
    #   h ={}
    #   h[:title] =e.record_time.strftime('%Y-%m-%d').to_s+"日  "+e.title+"  工单号:" +e.work_order_id.to_s+"    " +e.template_type+"  "
    #   h[:expand] = true
    #   wst = WorkLog.where(owner_type: "WorkShopTask",work_order_id: e.work_order_id)
    #   h[:children] = []
    #   wst.each do|f|

    #    h1 = {}
    #    h1[:title] = f.description
    #    h1[:expand] = true
    #    h1[:children] = WorkLog.where(owner_type:"WorkTeamTask",parent_id: f.owner_id).select("*,description as title")
    #    h[:children]<< h1
    #   end
    #   arr<< h
    # end

    # wst = WorkLog.where(owner_type: "WorkShopTask")
    # arr = []
    # wst.each do|e|
    #    h = {}
      
    #    h[:title] = e.description
    #    h[:expand] = true
    #    h[:children] = WorkLog.where(owner_type:"WorkTeamTask",parent_id: e.owner_id).select("*,description as title")
    #    arr << h
    # end

    render json:{
      data1: arr
    }
  end


  def workshop_logs

    work_logs = WorkLog.where(user_id:current_user.id)

    render json:{
      work_logs: work_logs
    }
  end


  def xialiao_shoptasks
    wst = WorkShopTask.joins(:work_shop).joins(work_order: :materials).joins(:user).where("work_shops.user_id=?",current_user.id).select("work_shop_tasks.id as wst_id,work_orders.id as id,materials.id as mid,materials.graph_no,materials.name as name,work_shops.name as shop_name,work_orders.number,materials.comment,users.username,work_shops.id as work_shop_id").order("work_shop_tasks.id asc")
    render json:{
      data: wst
    }
  end

  def give_task_to_team
    arr = []
    params[:procedure].split(",").each {|e| arr << WorkTeam.find(e).name}
    wtt = WorkTeamTask.new
    wtt.material_id = params[:mid]
    wtt.work_team_id = params[:procedure].split(",").first
    wtt.user_id = current_user.id
    wtt.record_time = Time.now
    wtt.number = params[:mnumber]
    wtt.work_shop_task_id = params[:wst_id]
    wtt.status = 0
    wtt.current_position = params[:procedure].split(",").first
    wtt.production_status = 1
    wtt.process = params[:procedure]
    
    if wtt.save
      msg = "分派成功"
      wtt.work_logs.create(parent_id:wtt.work_shop_task_id,get_user_id: WorkTeam.find_by_id(wtt.work_team_id).user_id ,number:wtt.number,user_id:current_user.id,work_order_id:params[:work_order_id],record_time: Time.now,description: User.find_by_id(current_user.id).username+" 于 "+Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s+" 分派 "+Material.find_by_id(params[:mid]).name+" 到: "+arr.join(",")+" ;数量："+params[:mnumber].to_s+" ;")

    else
      msg = "分派失败"
    end
    render json:{
      msg: msg
    }

  end


  def flow_finished
   
    wtt = WorkTeamTask.find_by_id(params[:team_task_id])
    arr = wtt.process.split(',')
    index = arr.index(wtt.current_position.to_s)
    
    if arr[index+1]
      wtt.current_position = arr[index+1]
      wtt.work_team_id = arr[index+1]
      wtt.finished_process =  wtt.finished_process ?  wtt.finished_process.to_s+","+wtt.work_team_id.to_s : wtt.work_team_id.to_s
      wtt.save
      msg ="完成并转入下一道工序"
    else
      wtt.status =2
      wtt.save
      msg ="进入质检"

    end

  
    render json:{
      msg: msg
    }
  end

  def zupin_finished

    wtt  =  WorkTeamTask.find_by_id(params[:id])
    wtt.status = 2
    wtt.paint = 1
    wtt.save
    
  end

  def paint_finished
    wtt = WorkTeamTask.find_by_id(params[:id])
    wtt.paint = 2 # 喷漆完成
    if wtt.save
      msg = "喷漆完成,可以出货"
    else
      msg = "提交失败"
    end
    render json:{
      msg: msg
    }
  end

  def painting_list
    wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_team_tasks.paint=1 and work_team_tasks.number- COALESCE(work_team_tasks.passed_number,0)=0").select("work_team_tasks.work_team_id,work_team_tasks.process,work_team_tasks.id as id,materials.id as mid,materials.work_order_id as wo_id, materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc")
    ws = WorkShop.where(dept_type:'喷漆').first  #因为只有一个
    pt = WorkTeam.where(work_shop_id: ws.id,status: 1 )
    render json:{
      data: wtt,
      teams: pt
    }

  end

  def give_painting_team_task
    wtt = WorkTeamTask.find_by_id(params[:task_id])
    wtt.paint_team = params[:painting_team]
    wtt.save
  end

  def painting_tasks
    ws = WorkShop.find_by_dept_type("喷漆")
    wt = WorkTeam.where(work_shop_id:ws.id,user_id:current_user.id).
    wtt = WorkTeamTask.joins(:work_team).joins(:material).joins(:user).where("work_team_tasks.paint=1 and work_team_tasks.number- COALESCE(work_team_tasks.passed_number,0)=0 and work_team_tasks.painting_team = ?",wt.id).select("work_team_tasks.work_team_id,work_team_tasks.process,work_team_tasks.id as id,materials.id as mid,materials.work_order_id as wo_id, materials.graph_no,materials.name as name,work_teams.name as team_name,work_team_tasks.number,work_team_tasks.finished_number,work_team_tasks.passed_number,materials.comment,users.username").order("work_team_tasks.id asc")
    render json:{
      data: wtt   
    }
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  private

  def materials_params
    params.require(:params).permit(:number,:graph_no,:name,:comment,:work_order_id)
  end

end
