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
    course_id = course.ids
    eva = Evaluation.select("id,name,status").where(status: '1').where(parent_id: 0).where("name is not null").order(:id).all
    eva_id = Evaluation.select("id,name").where(status: '1').where("name is not null").all.ids
    weight = Weight.where(courses_id:course_id,evaluations_id:eva_id).select(:courses_id,:evaluations_id,:weight).order(:courses_id)
    render json: { 'a': course, 'b': eva,'c': weight}
  end

  def patch_courseevallist
    begin
      course = Course.find(params.require(:params)[:id])

      if course.evaluations.empty?
      else
        weight = params.require(:params)[:weight]
        weight.each do |i|
        w = Weight.where(courses_id:params.require(:params)[:id],evaluations_id:i["id"])
        if w.empty?
        else
          w.update

        end
        Weight.create({courses_id:params.require(:params)[:id],evaluations_id:i["id"],weight:i["weight"]})
      end
      end

      course.evaluations.delete course.evaluations.where(term: params.require(:params)[:term])
      a = params.require(:params)[:checked_id]
      course.evaluations.push Evaluation.where(id: a).all

      
      course_id =Course.select("id,name").where(status: '1').where("name is not null").all.ids
      eva_id =Evaluation.select("id,name").where(status: '1').where(term: params.require(:params)[:term]).where("name is not null").all.ids
      weights = Weight.where(courses_id:course_id,evaluations_id:eva_id).select(:courses_id,:evaluations_id,:weight).order(:courses_id)
      
      render json: { 'a': course, 'b': weights}    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
