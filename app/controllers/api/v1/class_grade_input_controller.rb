class Api::V1::ClassGradeInputController < Api::V1::BaseController
  
  def get_tcourselist
    t_id = current_user.owner_id
    a = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id).select('courses_id').group('courses_id').order('courses_id')
    data = []
    a.length.times do|i|
      b={}
      b[:id]=a[i].courses_id
      b[:name]=Course.find(a[i].courses_id).name
      data.push(b)
    end
    render json: data
  end

  def post_tclasslist
    t_id = current_user.owner_id
    courses_id = params.require(:params)[:id]
      a = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id,courses_id: courses_id).select('class_rooms_id').order('class_rooms_id')
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


    term = Term.find(params.require(:params)[:term])
    Weight.where(courses_id:course_id).where("create_time between ? and ?",term.begin_time,term.end_time)
    e = course.evaluations.where(term: params.require(:params)[:term]).as_json
    ev = course.evaluations.where(term: params.require(:params)[:term])


    ev.length.times do |k|
      if(ev[k].parent!=nil)
        w = Weight.where(courses_id:course_id,evaluations_id:ev[k].id)[0].weight
        e[k]["name"]=ev[k].parent.name+'-'+e[k]["name"]+'('+w+')'
      else
        w = Weight.where(courses_id:course_id,evaluations_id:ev[k].id)[0].weight
        e[k]["name"]=e[k]["name"]+'('+w+')'
      end
    end
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

  def studentgradeList
    type = current_user.owner_type
    s_name = current_user.owner.name
    if type=='Student'      
      s_id = current_user.owner_id
      s = Student.find(s_id)
      c_name = s.class_room.name
      c_id = s.class_room.id
      t = TeachersClassesCourse.where(class_rooms_id:c_id).select("term").group("term").order("term")
      table_list = []
      grade_list = []
      t.length.times do |i|
        table_msg = []
        grade = []
        course = TeachersClassesCourse.where(class_rooms_id:c_id,term:t[i].term).select("courses_id").group("courses_id").order("courses_id")
        b = {}
        course.length.times do |j|
          e = []
          c = Course.find(course[j].courses_id).evaluations.where(term:t[i].term).select("id,parent_id,name,eno")
          bb =[]
          aa = {}
          aa["coursename"]=Course.find(course[j].courses_id).name
          c.length.times do |k|
            g = Grade.where(students_id:s_id,courses_id:course[j].courses_id,evaluations_id:c[k].id)
            if g.empty?
              aa[c[k].eno]='暂无成绩'
            else
              aa[c[k].eno]=g[0].grade
            end            
            a = {}
            if c[k].parent!=nil
              a["evalname"]=c[k].parent.name+'-'+c[k]["name"]
            else
              a["evalname"]=c[k].name
            end            
            a["eno"]=c[k].eno
            e.push(a.as_json)
          end
          b["eval"]=e
          b["coursename"]=Course.find(course[j].courses_id).name
          bb.push(aa.as_json)
          grade.push(bb)
          table_msg.push(b.as_json)
        end    
        grade_list.push(grade)    
        table_list.push(table_msg)
      end
      
      render json: {'a': s_name,'b': c_name,'c': table_list,'d': t,'e': grade_list}
    else
      render json: {'a': s_name}
    end    
  end

end
