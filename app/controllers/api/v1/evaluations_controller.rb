class Api::V1::EvaluationsController < Api::V1::BaseController
  
  def get_evaluationlist
    render json: Evaluation.where(status: '1').where(parent_id: 0).where("name is not null").all
  end

  def post_evaluationlist
    begin
      evaluation = Evaluation.new(evaluation_params)
      if evaluation.save!
        render json: evaluation
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
      if evaluation.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def evaluation_params
    params.require(:params).permit(:name, :eno, :types, :status, :description, :parent_id, :weight)
  end
end
