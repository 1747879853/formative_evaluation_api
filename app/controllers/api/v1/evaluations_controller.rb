class Api::V1::EvaluationsController < Api::V1::BaseController
  
  def get_evaluationlist
    render json: Evaluation.where(parent_id: 0).order(:name).all
    # render json: Evaluation.where(status:[0,1]).where(parent_id: 0).where("name is not null").order(:id).all
  end

  def post_evaluationlist
    begin
      parent_id = params.require(:params)[:parent_id]
      if parent_id == 0
        evaluation = Evaluation.new(evaluation_params)
        if evaluation.save!
          render json: evaluation
        end
      else
        # parent = Evaluation.find(parent_id)
        # parent.update(status: 2)
        # parent.children.update(status: 2)

        # new_parent = Evaluation.create({ name:parent.name,types:parent.types,status:1,description:parent.description,parent_id:0,in_class: parent.in_class })
        # parent.children.each do |i|
        #   Evaluation.create({ name:i.name,types:i.types,status:1,description:i.description,parent_id:new_parent.id,in_class: i.in_class })
        # end

        evaluation = Evaluation.create({ name: params.require(:params)[:name], types: params.require(:params)[:types], status: 1, description: params.require(:params)[:description], parent_id: parent_id, in_class: params.require(:params)[:in_class] })
        
        if evaluation.save!
          # render json: new_parent
          render json: Evaluation.find(parent_id)
        end
      end
      
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_evaluationlist
    begin
      # evaluation_id = params.require(:params)[:id]
      # evaluation = Evaluation.find(evaluation_id)

      # if evaluation.parent_id == 0       
      #   new_e = Evaluation.new(params.require(:params).permit(:name, :types, :description, :in_class))
      #   new_e.save!
      #   evaluation.children.each do |e|
      #     Evaluation.create({name:e.name,types:e.types,status:1,description:e.description,parent_id:new_e.id,in_class: e.in_class})
      #   end       

      #   evaluation.update(status: 2)
      #   evaluation.children.update(status: 2)

      #   render json: new_e

      #   #同步修改课程评价指标权重管理中的内容
      #   # maxtime = Weight.select("courses_id,max(create_time)").group(:courses_id)
      #   # course_id = []
      #   # maxtime.each do |i|
      #   #   a = Weight.where(courses_id:i.courses_id,create_time:i.max).select(:evaluations_id)
      #   #   a.each do |j|
      #   #     if evaluation_id==j.evaluations_id
      #   #       course_id.push(i.courses_id)
      #   #   end
      #   # end
      #   # courses = Course.where(id:course_id)
      #   # courses.each do |i|

      #   #   a = i.evaluations.map(&:id)-evaluations_id+new_e.id
      #   #   i.evaluations.delete i.evaluations
          
      #   #   i.evaluations.push Evaluation.where(id: a).all

      #   #   weight = params.require(:params)[:weight]
      #   #   time = Time.now
      #   #   weight.each do |i|
      #   #     Weight.create({courses_id:params.require(:params)[:id],evaluations_id:i["id"],weight:i["weight"],create_time:time})
      #   #   end

      #   # end


      # else
      #   evaluation_parent = Evaluation.find(evaluation.parent_id)

      #   new_parent = Evaluation.create({name:evaluation_parent.name,types:evaluation_parent.types,status:1,description:evaluation_parent.description,parent_id:0, in_class: evaluation_parent.in_class})
        
      #   evaluation_parent.children.each do |i|
      #     if i.id==evaluation_id
      #       eva = Evaluation.create({name:params.require(:params)[:name],types:params.require(:params)[:types],status:1,description:params.require(:params)[:description],parent_id:new_parent.id, in_class: params.require(:params)[:in_class]})
      #     else
      #       Evaluation.create({name:i.name,types:i.types,status:1,description:i.description,parent_id:new_parent.id,in_class:i.in_class})
      #     end
      #   end

      #   evaluation_parent.update(status: 2)
      #   evaluation_parent.children.update(status: 2)

      #   render json: new_parent
      # end

      evaluation_id = params.require(:params)[:id]
      evaluation = Evaluation.find(evaluation_id)
      evaluation.name = params.require(:params)[:name]
      evaluation.save!
      render json: evaluation
        
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_evaluationlist
    begin
      # evaluation_id = params.require(:params)[:id]
      # evaluation = Evaluation.find(evaluation_id)
      # if evaluation.update(params.require(:params).permit(:status)) && evaluation.children.update(params.require(:params).permit(:status))
      #   render json: { }
      # end

      evaluation_id = params.require(:params)[:id]
      evaluation = Evaluation.find_by(id: evaluation_id)
      p evaluation_id
      if evaluation
        # all ids of evaluation that needed to delete
        del_eva_ids = evaluation.children.map(&:id)
        del_eva_ids.push(evaluation_id)
        p del_eva_ids

        ce = CoursesEvaluation.where(evaluation_id: del_eva_ids)
        ce.delete_all if ce.length > 0 
        th = TeaHomework.where(evaluations_id: del_eva_ids)
        th.delete_all if th.length > 0
        
        w = Weight.where(evaluations_id: del_eva_ids)
        w.delete_all if w.length > 0

        evaluation.children.delete_all
        evaluation.delete
      end
      render json: {}


    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def evaluation_params
    params.require(:params).permit(:name, :types, :status, :description, :parent_id, :in_class)
  end

  def get_termlist_e
    term = []
    t = Evaluation.select('term').group('term').order('term')
    t.length.times do |i|
      term.push(t[i].term)
    end
    render json: term
  end

end
