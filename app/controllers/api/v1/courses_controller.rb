class Api::V1::CoursesController < Api::V1::BaseController
  
  def get_courselist
    render json: Course.where(status: '1').where("name is not null").all
  end

  def post_courselist
    begin
      course = Course.new(course_params)
      if course.save!
        render json: course
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_courselist
    begin
      course_id = params.require(:params)[:id]
      course = Course.find(course_id)
      if course.update(course_params)
        render json: course
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_courselist
    begin
      course_id = params.require(:params)[:id]
      course = Course.find(course_id)
      if course.update(params.require(:params).permit(:status))
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def course_params
    params.require(:params).permit(:name, :cno, :status)
  end
end
