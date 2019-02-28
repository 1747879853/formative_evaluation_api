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

  def get_courseevallist
    course = Course.select("id,name").where(status: '1').where("name is not null").all
    eva = Evaluation.select("id,name,status").where(status: '1').where(parent_id: 0).where("name is not null").order(:id).all
    maxtime = Weight.select("courses_id,max(create_time)").group(:courses_id)
    weight = []
    maxtime.each do |i|
      a = Weight.where(courses_id:i.courses_id,create_time:i.max).select(:courses_id,:evaluations_id,:weight).as_json
      weight = weight + a
    end
    render json: { 'a': course, 'b': eva,'c': weight}
  end

  def patch_courseevallist
    begin
      course = Course.find(params.require(:params)[:id])

      course.evaluations.delete course.evaluations
      a = params.require(:params)[:checked_id]
      course.evaluations.push Evaluation.where(id: a).all

      weight = params.require(:params)[:weight]
      time = Time.now
      weight.each do |i|
        Weight.create({courses_id:params.require(:params)[:id],evaluations_id:i["id"],weight:i["weight"],create_time:time})
      end

      maxtime = Weight.select("courses_id,max(create_time)").group(:courses_id)
      weights = []
      maxtime.each do |i|
        a = Weight.where(courses_id:i.courses_id,create_time:i.max).select(:courses_id,:evaluations_id,:weight).as_json
        weights = weights + a
      end

      render json: { 'a': course, 'b': weights}    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
