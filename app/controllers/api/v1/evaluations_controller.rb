class Api::V1::EvaluationsController < Api::V1::BaseController
  
  def get_evaluationlist
    render json: Evaluation.where(status:[0,1]).where(parent_id: 0).where("name is not null").order(:id).all
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
        parent = Evaluation.find(parent_id)
        parent.update(status: 2)
        parent.children.update(status: 2)

        new_parent = Evaluation.create({ name:parent.name,types:parent.types,status:1,description:parent.description,parent_id:0 })
        parent.children.each do |i|
          Evaluation.create({ name:i.name,types:i.types,status:1,description:i.description,parent_id:new_parent.id })
        end

        evaluation = Evaluation.create({ name:params.require(:params)[:name],types:params.require(:params)[:types],status:1,description:params.require(:params)[:description],parent_id:new_parent.id })
        
        if evaluation.save!
          render json: evaluation
        end
      end
      
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_evaluationlist
    begin
      evaluation_id = params.require(:params)[:id]
      evaluation = Evaluation.find(evaluation_id)
      if evaluation.update(params.require(:params).permit(:name, :eno, :types, :description))
        render json: evaluation
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_evaluationlist
    begin
      evaluation_id = params.require(:params)[:id]
      evaluation = Evaluation.find(evaluation_id)
      if evaluation.update(params.require(:params).permit(:status)) && evaluation.children.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def evaluation_params
    params.require(:params).permit(:name, :eno, :types, :status, :description, :parent_id)
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
