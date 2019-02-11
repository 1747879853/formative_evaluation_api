class Api::V1::TeachersController < Api::V1::BaseController
  
  def get_teacherlist
    render json: Teacher.where(status: '1').where("name is not null").all
  end

  def post_teacherlist
    begin
      teacher = Teacher.new(teacher_params)
      if teacher.save!
        user = User.new
        user.password='password'
        user.owner = teacher
        user.username = teacher.name
        user.email = teacher.email
        user.tel = teacher.tel
        user.save!
        render json: teacher
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_teacherlist
    begin
      teacher_id = params.require(:params)[:id]
      teacher = Teacher.find(teacher_id)
      if teacher.update(teacher_params)
        user_id = User.where(owner_id: teacher_id).where("owner_type='Teacher'").ids
        user = User.find(user_id[0])
        user.username = teacher.name
        user.email = teacher.email
        user.tel = teacher.tel
        user.save!
        render json: teacher
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_teacherlist
    begin
      teacher_id = params.require(:params)[:id]
      teacher = Teacher.find(teacher_id)
      if teacher.update(params.require(:params).permit(:status))
        user_id = User.where(owner_id: teacher_id).where("owner_type='Teacher'").ids
        user = User.find(user_id[0])
        user.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def teacher_params
    params.require(:params).permit(:name, :email, :tel, :year, :status, :tno)
  end

  def get_teachercourselist
    render json: { 'a': Teacher.select("id,name").where(status: '1').where("name is not null").all, 'b': Course.select("id,name").where(status: '1').where("name is not null").all}
  end

  def patch_teachercourselist
    begin
      teacher = Teacher.find(params.require(:params)[:id])
      teacher.courses.delete_all
      a = params.require(:params)[:checked_id]
      teacher.courses.push Course.where(id: a).all
      render json: teacher    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
