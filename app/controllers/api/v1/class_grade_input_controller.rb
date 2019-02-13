class Api::V1::ClassGradeInputController < Api::V1::BaseController
  
  def get_tcourselist
    t_id = current_user.owner.as_json["id"]
    year = Time.now.year.to_s
    month = Time.now.month
    if month>7
      term = year+'秋季学期'      
    else
      term = year+'春季学期'
    end
    a = TeachersClassesCourse.where(term: term,teachers_id: t_id).select('courses_id').group('courses_id').order('courses_id')
    data = []
    a.length.times do|i|
      b={}
      b[:id]=a[i].courses_id
      b[:name]=Course.find(a[i].courses_id).name
      data.push(b)
    end
    render json: {'a': data,'b': term,}
  end

  def post_tclasslist
    t_id = current_user.owner.as_json["id"]
    courses_id = params.require(:params)[:id]
    year = Time.now.year.to_s
    month = Time.now.month
    if month>7
      a = TeachersClassesCourse.where(term: year+'秋季学期',teachers_id: t_id,courses_id: courses_id).select('class_rooms_id').order('class_rooms_id')
    else
      a = TeachersClassesCourse.where(term: year+'春季学期',teachers_id: t_id,courses_id: courses_id).select('class_rooms_id').order('class_rooms_id')
    end
    data = []
    a.length.times do|i|
      b={}
      b[:id]=a[i].class_rooms_id
      b[:name]=ClassRoom.find(a[i].class_rooms_id).name
      data.push(b)
    end
    render json: data
  end

  def get_classgrade
    course_id = params.require(:params)[:course_id]
    class_id = params.require(:params)[:class_id]
    s = Student.select("id,name,sno").where(status: 1).where(class_room_id: class_id).as_json
    course = Course.find(course_id)
    e = course.evaluations.as_json
    s.length.times do |i|
      e.length.times do |j|
        eno = e[j]["eno"]
        a = Grade.select("grade").where(students_id:s[i]["id"],evaluations_id:e[j]["id"],courses_id:course_id).as_json
        if a.empty?
          s[i][eno]=''
        else
          s[i][eno]=a[0]["grade"]
        end
      end
    end
    render json: {'a': e,'b': s}
  end

  def inputclassgrade
    students_id = params.require(:params)[:students_id]
    courses_id = params.require(:params)[:courses_id]
    evallist = params.require(:params)[:eval]
    a = []
    evallist.length.times do |i|
      if evallist[i]["stu"] == students_id
        g = Grade.where(students_id:students_id,courses_id:courses_id,evaluations_id:evallist[i]["id"])
        if g.empty?
          Grade.create(students_id:students_id,courses_id:courses_id,evaluations_id:evallist[i]["id"],grade:evallist[i]["grade"])
        else
          g.update(grade:evallist[i]["grade"])
        end
        a.push(evallist[i])
      end
    end
    render json: a
  end

end
