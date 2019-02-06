class Api::V1::ClassRoomsController < Api::V1::BaseController
  
  def get_classroomlist
    render json: ClassRoom.where(status: '1').where("name is not null").all
  end

  def post_classroomlist
    begin
      classroom = ClassRoom.new(classroom_params)
      if classroom.save!
        render json: classroom
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_classroomlist
    begin
      classroom_id = params.require(:params)[:id]
      classroom = ClassRoom.find(classroom_id)
      if classroom.update(classroom_params)
        render json: classroom
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_classroomlist
    begin
      classroom_id = params.require(:params)[:id]
      classroom = ClassRoom.find(classroom_id)
      if classroom.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def classroom_params
    params.require(:params).permit(:name, :clno, :year, :status)
  end
end
