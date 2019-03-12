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
        user.email = teacher.tno
        user.tel = teacher.tel
        user.save!

        user.auth_groups.push AuthGroup.find_by(title: '老师')
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
        user.email = teacher.tno
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

  # def get_termlist
  #   term = []
  #   t = TeachersClassesCourse.select('term').group('term').order('term')
  #   t.length.times do |i|
  #     term.push(t[i].term)
  #   end
  #   render json: term
  # end

  def post_tcclist
    t = Teacher.select("id,name").where(status: '1').where("name is not null").all.as_json
    t.length.times do |i|
      a = TeachersClassesCourse.where(term: params.require(:params)[:term] ,teachers_id: t[i]["id"]).select('class_rooms_id').group('class_rooms_id').order('class_rooms_id')
      b = []
      checked_course = []

      a.length.times do |j|
        item = {}
        b.push(a[j].class_rooms_id)
        c = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t[i]["id"],class_rooms_id: a[j].class_rooms_id).select('courses_id')
        d = []
        c.length.times do |k|
          d.push(c[k].courses_id)
        end
        item[:class_id]=a[j].class_rooms_id
        item[:classname]=ClassRoom.where(id: a[j].class_rooms_id).as_json[0]["name"]
        item[:checked_id]=d
        checked_course.push(item)
      end
      t[i][:checked_class_id] = b
      t[i][:checked_course] = checked_course
    end

    render json: { 'a': t,'b': ClassRoom.select("id,name").where(status: '1').where("name is not null").all,
                   'c': Course.select("id,name").where(status: '1').where("name is not null").all}
  end

  def patch_tcclist
    begin
      term = params.require(:params)[:term]
      t_id = params.require(:params)[:id]
      checked_course = params.require(:params)[:checked_course]
      checked_class_id = params.require(:params)[:checked_class_id]

      tcc = TeachersClassesCourse.where(teachers_id: t_id,term: term)
      tcc.destroy_all

      checked_course.length.times do |i|
        checked_course[i]["checked_id"].length.times do |j|
          TeachersClassesCourse.create({teachers_id: t_id,class_rooms_id: checked_course[i]["class_id"],courses_id: checked_course[i]["checked_id"][j],term: term})
        end
      end

      render json: { 'checked_course': checked_course, 'checked_class_id': checked_class_id }    
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

end
