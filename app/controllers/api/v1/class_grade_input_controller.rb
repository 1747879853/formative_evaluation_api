class Api::V1::ClassGradeInputController < Api::V1::BaseController
  
  # def get_tcourselist
  #   t_id = current_user.owner_id
  #   a = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id).select('courses_id').group('courses_id').order('courses_id')
  #   data = []
  #   a.length.times do|i|
  #     b={}
  #     b[:id]=a[i].courses_id
  #     b[:name]=Course.find(a[i].courses_id).name
  #     data.push(b)
  #   end
  #   render json: data
  # end

  def post_tclasslist
    t_id = current_user.owner_id

    # TeachersClassesCourse存放:  教师id-班级id-课程id-学期id 之间的对应关系
    # <TeachersClassesCourse id: 60, teachers_id: 9, class_rooms_id: 13, courses_id: 16, term: "7", status: 2>
    a = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id).select('class_rooms_id').group('class_rooms_id').order('class_rooms_id')
    data = []
    a.length.times do|i|
      b={}
      b[:id]=a[i].class_rooms_id
      b[:name]=ClassRoom.find(a[i].class_rooms_id).name
      c = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id,class_rooms_id:a[i].class_rooms_id).select('courses_id').group('courses_id').order('courses_id').as_json
      b[:course]=[]
      c.each do |j|
        b[:course].push({"id" => j["courses_id"],"name" => Course.find(j["courses_id"]).name,"status" => TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id,class_rooms_id:a[i].class_rooms_id,courses_id:j["courses_id"])[0].status})
      end      
      data.push(b)
    end
    render json: data
  end

  def get_classgrade   #根据学期term、班级class_id、课程course_id,查成绩
    t_id = current_user.owner_id
    course_id = params.require(:params)[:course_id]
    class_id = params.require(:params)[:class_id]
    st = TeachersClassesCourse.where(teachers_id:t_id,courses_id:course_id,class_rooms_id:class_id,term:params.require(:params)[:term]).select(:status)
    

    if st[0]["status"]==2  #已经提交了成绩，不能再修改
      
      s = Student.select("id,name,sno").where(status: 1).where(class_room_id: class_id).as_json
      course = Course.find(course_id)

      #这种情况的评价指标应该从grades表里面取
      # ee = Weight.where(courses_id:course_id).where(status:1).select(:evaluations_id)
      ee = Grade.where(term:params.require(:params)[:term],courses_id:course_id).select(:evaluations_id).group(:evaluations_id)
      eee = []
      ee.each do |i|
        eee.push(i.evaluations_id)
      end
      e = Evaluation.where(id:eee).as_json
      ev = Evaluation.where(id:eee)


      ev.length.times do |k|
        if(ev[k].parent!=nil)
          w = Weight.where(courses_id:course_id,evaluations_id:ev[k].id)[0].weight
          pw = Weight.where(courses_id:course_id,evaluations_id:ev[k].parent.id)[0].weight
          e[k]["name"]=ev[k].parent.name+'('+pw+')'+'-'+e[k]["name"]+'('+w+')'
        else
          w = Weight.where(courses_id:course_id,evaluations_id:ev[k].id)[0].weight
          e[k]["name"]=e[k]["name"]+'('+w+')'
        end
      end
      s.length.times do |i|
        e.length.times do |j|
          e_id = 'e'+e[j]["id"].to_s
          a = Grade.select("grade").where(students_id:s[i]["id"],evaluations_id:e[j]["id"],courses_id:course_id,term:params.require(:params)[:term]).as_json
          if a.empty?
            s[i][e_id]=''
          else
            s[i][e_id]=a[0]["grade"]
          end
        end
      end
      render json: {'a': e,'b': s,'c': 'uneditable'}

    else

      s = Student.select("id,name,sno").where(status: 1).where(class_room_id: class_id).as_json
      course = Course.find(course_id)

      term = Term.find(params.require(:params)[:term])
      ee = Weight.where(courses_id:course_id).where(status:1).select(:evaluations_id)
      eee = []
      ee.each do |i|
        eee.push(i.evaluations_id)
      end
      e = Evaluation.where(id:eee).as_json
      ev = Evaluation.where(id:eee)
      e_question = Evaluation.where(id:eee,types:'classroom_question').where.not(parent_id: 0).as_json

      ev.length.times do |k|
        if(ev[k].parent!=nil)
          w = Weight.where(courses_id:course_id,evaluations_id:ev[k].id)[0].weight
          pw = Weight.where(courses_id:course_id,evaluations_id:ev[k].parent.id)[0].weight
          e[k]["name"]=ev[k].parent.name+'('+pw+')'+'-'+e[k]["name"]+'('+w+')'
        else
          w = Weight.where(courses_id:course_id,evaluations_id:ev[k].id)[0].weight
          e[k]["name"]=e[k]["name"]+'('+w+')'
        end
      end
      s.length.times do |i|
        e.length.times do |j|
          e_id = 'e'+e[j]["id"].to_s
          a = Grade.select("grade").where(students_id:s[i]["id"],evaluations_id:e[j]["id"],courses_id:course_id,term:params.require(:params)[:term]).as_json
          if a.empty? or a[0]["grade"] == nil
            s[i][e_id]=''
          else
            s[i][e_id]=a[0]["grade"]
          end
        end
        sum = 0
        e_question.each do |k|
          aa = Grade.select("grade").where(students_id:s[i]["id"],evaluations_id:k["id"],courses_id:course_id,term:params.require(:params)[:term]).as_json
          if aa.empty? or aa[0]["grade"] == nil
            
          else
            sum = sum + 1
          end
          # puts '************'
          # puts aa
          # puts '************'
        end
        s[i]['count']=sum
      end
      render json: {'a': e,'b': s,'c': 'editable'}

    end
    
  end

  def inputclassgrade
    t_id = current_user.owner_id
    status = params.require(:params)[:status]
    courses_id = params.require(:params)[:courses_id]
    evallist = params.require(:params)[:eval]
    class_id = params.require(:params)[:class_id]
    term = params.require(:params)[:term]

    tcc = TeachersClassesCourse.where(teachers_id:t_id,class_rooms_id:class_id,courses_id:courses_id,term:term)
    tcc.update(status:status)

    a = []
    evallist.length.times do |i|
      g = Grade.where(students_id:evallist[i]["stu"],courses_id:courses_id,evaluations_id:evallist[i]["id"])
      if g.empty?
        Grade.create(students_id:evallist[i]["stu"],courses_id:courses_id,evaluations_id:evallist[i]["id"],grade:evallist[i]["grade"],class_rooms_id:class_id,term:term)
      else
        g.update(grade:evallist[i]["grade"])
      end
      a.push(evallist[i])
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
      term = []
      t.length.times do |i|
        term.push(Term.find(t[i].term))
        table_msg = []
        grade = []
        course = TeachersClassesCourse.where(class_rooms_id:c_id,term:t[i].term,status:2).select("courses_id").group("courses_id").order("courses_id")
        b = {}
        course.length.times do |j|
          e = []

          ee = Grade.where(term:t[i].term,courses_id:course[j].courses_id).select(:evaluations_id).group(:evaluations_id)
          eee = []
          ee.each do |l|
            eee.push(l.evaluations_id)
          end
          c = Evaluation.where(id:eee).select("id,parent_id,name")

          # c = Course.find(course[j].courses_id).evaluations.where(term:t[i].term).select("id,parent_id,name,eno")
          bb =[]
          aa = {}
          aa["coursename"]=Course.find(course[j].courses_id).name
          c.length.times do |k|
            g = Grade.where(students_id:s_id,courses_id:course[j].courses_id,evaluations_id:c[k].id,term:t[i].term)
            if g.empty?
              aa['e'+c[k].id.to_s]='暂无成绩'
            else
              aa['e'+c[k].id.to_s]=g[0].grade
            end            
            a = {}
            if c[k].parent!=nil
              a["evalname"]=c[k].parent.name+'-'+c[k]["name"]
            else
              a["evalname"]=c[k].name
            end  
            a["id"]=c[k].id         
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
      
      render json: {'a': s_name,'b': c_name,'c': table_list,'d': term,'e': grade_list}
    else
      render json: {'a': s_name}
    end    
  end

end
