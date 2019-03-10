class Api::V1::CoursesController < Api::V1::BaseController
  
  def get_courselist
    render json: Course.where(status: '1').where("name is not null").all.order(:name)
    # ret = []
    # cc.each do |e|
    #   ret << {e}
    # end
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
    params.require(:params).permit(:name, :cno, :brief,:status)
  end

  def get_courseevallist
    course = Course.select("id,name").where(status: '1').where("name is not null").all
    eva = Evaluation.select("id,name,status").where(status: '1').where(parent_id: 0).where("name is not null").order(:id).all
    weights = Weight.where(status:1).select(:courses_id,:evaluations_id,:weight,:status)
    render json: { 'a': course, 'b': eva,'c': weights}
  end

  def patch_courseevallist
    begin
      course = Course.find(params.require(:params)[:id])

      course.evaluations.delete course.evaluations
      a = params.require(:params)[:checked_id]
      course.evaluations.push Evaluation.where(id: a).all

      weight = params.require(:params)[:weight]
      c_e = Weight.where(courses_id:params.require(:params)[:id],status:1)
      weight.each do |i|
        v = true
        c_e.each do |j|
          if i["id"] ==j.evaluations_id
            v = false
            puts '++++++++++++++++++++++++++++++++++++++'
            break
          end
        end
        if v == true
          Weight.create({courses_id:params.require(:params)[:id],evaluations_id:i["id"],weight:i["weight"],status:1})
        end
      end

      c_e.each do |i|
        v = true
        weight.each do |j|
          if i.evaluations_id ==j["id"]
            v = false
            break
          end
        end
        if v == true
          i.update(status:0)
        end
      end

      weights = Weight.where(status:1).select(:courses_id,:evaluations_id,:weight,:status)

      render json: { 'a': course, 'b': weights}    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
