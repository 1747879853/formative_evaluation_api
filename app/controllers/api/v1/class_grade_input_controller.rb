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

  def post_tclasslist_question
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
        status = TeachersClassesCourse.where(term: params.require(:params)[:term],teachers_id: t_id,class_rooms_id:a[i].class_rooms_id,courses_id:j["courses_id"])[0].status
        if status == 2
          ee = Grade.where(term:params.require(:params)[:term],courses_id:j["courses_id"]).select(:evaluations_id).group(:evaluations_id)
          eee = []
          ee.each do |i|
            eee.push(i.evaluations_id)
          end

          ev = Evaluation.where(id:eee,types:'classroom_question')
          if ev.empty? or ev[0].id ==nil
          else
            b[:course].push({"id" => j["courses_id"],"name" => Course.find(j["courses_id"]).name,"status" => status})
          end
        else
          ee = Weight.where(courses_id:j["courses_id"]).where(status:1).select(:evaluations_id)
          eee = []
          ee.each do |i|
            eee.push(i.evaluations_id)
          end

          ev = Evaluation.where(id:eee,types:'classroom_question')
          if ev.empty? or ev[0].id ==nil
          else
            b[:course].push({"id" => j["courses_id"],"name" => Course.find(j["courses_id"]).name,"status" => status})
          end
        end
        # b[:course].push({"id" => j["courses_id"],"name" => Course.find(j["courses_id"]).name,"status" => status})
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
    
    if st.empty?
      render json: {'a': [],'b': [],'c': 'uneditable'}
    
    elsif st[0]["status"]==2  #已经提交了成绩，不能再修改
      
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

          if e[j]["types"].to_s == 'text-score'
            th = TeaHomework.where(teachers_id:t_id,courses_id:course_id,term:params.require(:params)[:term],evaluations_id:e[j]["id"])
            if th.length>0 
              th_id = th[0].id
              sh = StuHomework.where(students_id:s[i]["id"],tea_homeworks_id:th_id).select(:status)
              if sh.length>0
                s[i][e_id+'status']=sh[0].status
              else
                s[i][e_id+'status']=0
              end
            else
              s[i][e_id+'status']=0
            end            
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
      e_question = Evaluation.where(id:eee,types:'classroom_question').as_json

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

          if e[j]["types"].to_s == 'text-score'
            th = TeaHomework.where(teachers_id:t_id,courses_id:course_id,term:params.require(:params)[:term],evaluations_id:e[j]["id"])
            if th.length>0 
              th_id = th[0].id
              sh = StuHomework.where(students_id:s[i]["id"],tea_homeworks_id:th_id).select(:status)
              if sh.length>0
                s[i][e_id+'status']=sh[0].status
              else
                s[i][e_id+'status']=0
              end
            else
              s[i][e_id+'status']=0
            end            
          end
          
        end
        sum = 0
        e_question.each do |k|
          aa = Grade.select("grade").where(students_id:s[i]["id"],evaluations_id:k["id"],courses_id:course_id,term:params.require(:params)[:term]).as_json
          if aa.empty? or aa[0]["grade"] == nil or aa[0]["grade"] == ''
            
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

  def inputclassgrade #暂存
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
      sum = 0
      g = Grade.where(students_id:evallist[i]["stu"],courses_id:courses_id,evaluations_id:evallist[i]["id"],term:term)
      # the grade record is not exist,so added
      if g.empty? and evallist[i]["grade"]!=nil and evallist[i]["grade"]!=''
        sum = sum +1
        Grade.create(students_id:evallist[i]["stu"],courses_id:courses_id,evaluations_id:evallist[i]["id"],grade:evallist[i]["grade"],class_rooms_id:class_id,term:term,record_time:Time.now)
      # the grade record exist and score not null, but new score(the params) is null, so this is 原来填写了成绩，后来又清空
      elsif !g.empty? and evallist[i]["grade"] == '' and g[0]["grade"] != ''
        sum = sum -1
        # g.update(grade:evallist[i]["grade"],record_time:Time.now)
        g[0].delete

      # the grade record exist and new score(the params) is not null, so this is 修改成绩
      elsif !g.empty? and evallist[i]["grade"] != '' and evallist[i]["grade"]!=nil
        sum = sum +1
        g.update(grade:evallist[i]["grade"],record_time:Time.now)
      # the grade record exist and new score(the params) is not null  , so this is 修改成绩
      elsif !g.empty? and evallist[i]["grade"] != '' and g[0]["grade"] != ''
        g.update(grade:evallist[i]["grade"],record_time:Time.now)
      end
      evallist[i]["count"]=sum
      a.push(evallist[i])
    end
    render json: {'a': a}
  end

  def studentgradeList
    arr = []
    arr2 = []
    
    n = 1
    arr3 =[]
    type = current_user.owner_type
    s_name = current_user.owner.name
    if type=='Student'

      s_id = current_user.owner_id
      s = Student.find(s_id)
      c_name = s.class_room.name
      c_id = s.class_room.id
      id_list=[]
      arr_ =[]

      t = TeachersClassesCourse.where(class_rooms_id:c_id).where("term != ''").select("term").group("term").order("term")
      #班级id是唯一的，对应的学期可能有多个
      table_list = []
      grade_list = []
      term = []
      teachers_id=[]
      tea_comment_list=[]
      
      t.length.times do |i|
        if defined?t[i].term
        else
          next
        end
        #teachers_id.push(t[i].teachers_id)
        #tea_home_id=
        term.push(Term.find(t[i].term))
        table_msg = []
        grade = []
        course = TeachersClassesCourse.where(class_rooms_id:c_id,term:t[i].term,status:[1,2]).select("courses_id").group("courses_id").order("courses_id")
        #根据唯一班级id查找在本学期上的课程
        b = {}
        course.length.times do |j|
          e = []
          #查找本学期，本课程的评估id（评估id可能一对多）可能有多个评价指标
          ee = Grade.where(term:t[i].term,courses_id:course[j].courses_id).select(:evaluations_id).group(:evaluations_id)
          eee = []
          ee.each do |l|
            eee.push(l.evaluations_id)
          end
          c = Evaluation.where(id:eee).select("id,parent_id,name")
          #根据评价指标id查找父id以及名字
          # c = Course.find(course[j].courses_id).evaluations.where(term:t[i].term).select("id,parent_id,name,eno")
          bb =[]
          aa = {}
          aa["coursename"]=Course.find(course[j].courses_id).name
          c.length.times do |k|
            g = Grade.where(students_id:s_id,courses_id:course[j].courses_id,evaluations_id:c[k].id,term:t[i].term)
            evaluation_types =[]
            evaluation_types = Evaluation.where(id:c[k].id).select("types")
            
            arr3 = evaluation_types[0].types
            #teacher_id=TeachersClassesCourse.where(courses_id:course[j].courses_id,term:t[i].term,class_rooms_id:s.class_room.id).select("teachers_id")
            #################!!!!!!!!!!!!!
            
            #tea_homework_id = TeaHomework.where(courses_id:course[j].courses_id,evaluations_id:c[k].id,term:t[i].term,teachers_id:teacher_id[0].teachers_id).select("id")
            #if tea_homework_id!=nil
              #tea_comment=StuHomework.where(students_id:s_id,tea_homeworks_id:tea_homework_id[0].id).select("tea_comment")
              #tea_comment_list.push(tea_comment[0].tea_comment)
            #else
            #end
            if g.empty?
              aa['e'+c[k].id.to_s]='暂无成绩'
            else
              if evaluation_types[0].types == 'score'||evaluation_types[0].types == 'text-score'
                arr = Grade.where(courses_id:course[j].courses_id,evaluations_id:c[k].id,term:t[i].term,class_rooms_id:c_id).select("grade")
                arr2 =[]
                arr.each do |o|
                  arr2.push(o.grade.to_f)
                  arr_.push(o.grade.to_f)
                end
                arr2.sort!{|x,y| y <=> x }
                for p in arr2
                  if g[0].grade.to_f == p
                    break
                  end
                  n=n+1
                end
                aa['e'+c[k].id.to_s]=g[0].grade.to_s+" 排名(#{n})"
                n = 1
                arr = []
                arr2 = []
               evaluation_types = []
              else
                puts "+++++++++++"
                aa['e'+c[k].id.to_s]=g[0].grade.to_s
              end
              #aa['tea_comment']=g[0].
            end        
            #tea_comment=StuHomework.where(students_id:s_id,tea_homeworks_id:tea_homework_id[0].id).select("tea_comment")
            
            #tea_comment_list.push(tea_comment[0].tea_comment)
           # id_list.push(tea_homework_id[0])
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
      
      render json: {'a': s_name,'b': c_name,'c': table_list,'d': term,'e': grade_list,'g':id_list,'i': n,'h': arr_,'i': c_id}
    else
      render json: {'a': s_name}
    end    
  end

  def output_grades
    checked_teachers = params[:teacher]
    checked_courses = params[:course]
    checked_term = params[:term]
    checked_class_rooms = params[:class_room]
    checked_term = checked_term.to_s
    checked_courses_id = ''
    checked_teachers_id = ''
    checked_class_rooms_id = ''
    a = []
    b = []
    
    checked_courses.each do |i|
      checked_courses_id.concat(Course.where(name: i).select(:id).first.id.to_s+",")
      a.push Course.where(name: i).select(:id).first.id
    end
    checked_courses_id = checked_courses_id.chop
    checked_class_rooms.each do |k|
      checked_class_rooms_id.concat(ClassRoom.where(name: k).select(:id).first.id.to_s+",")
      b.push ClassRoom.where(name: k).select(:id).first.id
    end
    checked_class_rooms_id = checked_class_rooms_id.chop
    checked_teachers.each do |j|
      checked_teachers_id.concat(Teacher.where(name: j).select(:id).first.id.to_s+",")
    end
    checked_teachers_id = checked_teachers_id.chop
   # times = Grade.where("class_rooms_id IN (#{checked_class_rooms_id})").where("courses_id IN (#{checked_courses_id})").where(term:checked_term)
    res = []
    t = {}
    selet_res = Grade.find_by_sql("select grades.grade,students.name as students_name,students.sno,courses.name as course_name,class_rooms.name as class_rooms_name,teachers.name as teachers_name,evaluations.name as evaluations_name,evaluations.description,grades.evaluations_id from ((grades inner join teachers_classes_courses on grades.class_rooms_id=teachers_classes_courses.class_rooms_id AND grades.courses_id=teachers_classes_courses.courses_id AND grades.term=teachers_classes_courses.term) inner join teachers on teachers_classes_courses.teachers_id=teachers.id) inner join students on grades.students_id = students.id inner join courses on grades.courses_id=courses.id inner join class_rooms on grades.class_rooms_id=class_rooms.id inner join evaluations on grades.evaluations_id=evaluations.id where grades.class_rooms_id IN (#{checked_class_rooms_id}) AND grades.courses_id IN (#{checked_courses_id}) AND teachers.id IN (#{checked_teachers_id}) AND grades.term='#{checked_term}';")
    #selet_res.each do |i|


    
    selet_res.each do |i|
      
        t["teachers_name"] = i.teachers_name
        t["students_name"] = i.students_name
        t["students_num"] = i.sno
        t["course_name"] = i.course_name
        t["class_rooms_name"] = i.class_rooms_name
        t["grade"] = i.grade
        
        t["description"] = i.description
        if Evaluation.find(i.evaluations_id).parent_id == 0
          t["evaluations"] = i.evaluations_name
        else
          t["evaluations"] = Evaluation.find(Evaluation.find(i.evaluations_id).parent_id).name+"-"+Evaluation.find(i.evaluations_id).name
        end
        res.push t
        t = {}
    end
    
   
      
    #res = Grade.select("grades.grade,students.name,courses.name,class_rooms.name,evaluations.name,evaluations.description").joins("inner join teachers on teachers_classes_courses.teachers_id=teachers.id) inner join students on grades.students_id = students.id inner join courses on grades.courses_id=courses.id inner join class_rooms on grades.class_rooms_id=class_rooms.id inner join evaluations on grades.evaluations_id=evaluations.id")

    render json: {'checked_teachers_id': checked_teachers_id,'checked_class_rooms_id': checked_class_rooms_id,'checked_courses_id': checked_courses_id,'e': a,'f': b,'k': res,'l': checked_term}
  end

  def get_detail_achieve
    render json: {'term': Term.all}  
  end

  def get_teacher_course
    term_id = params[:term]
    final_list = []
    b={}
    #User.where(id: current_user.id).
    teacher_class_course = TeachersClassesCourse.where(teachers_id: current_user.owner_id).where(term: term_id)
    teacher_class_course.each do |i|
      b[:class_room_id] = i.class_rooms_id
      b[:name] = ClassRoom.where(id: i.class_rooms_id).first.name + Course.where(id: i.courses_id).first.name
      b[:course_id] = i.courses_id
     # b[:course_name] = 
      final_list.push(b)
      b = {}
    end
    render json: {'a': final_list}
  end

  def  get_detail_list
    begin
    students_list = []
    student_grade_list = []
    evaluations_weight = []
    b = {}
    bbb = []
    uuu = []
    parents = []
    parents_flag = []
    flag =0
    evaluations_id_falg = []
    evaluations_id_falg_ = []
    we = 0
    term_id = params[:term]
    class_room_id = params[:class_room_id]
    course_id = params[:course_id]
    students_list = Student.where(class_room_id: class_room_id).where(status:1).select(:id,:name,:sno)
    course_eva = CoursesEvaluation.where(course_id:course_id)

    eva_we = []
    eva_par_id = []
    eva_id =[]

    grade_lists = Grade.where(courses_id:course_id).where(term:term_id).where(class_rooms_id:class_room_id).where(term:term_id)
    grade_lists.each do |i|
      eva = Evaluation.where(id: i.evaluations_id).first
      if eva == nil
        next
      else
        if !(eva_par_id .include? eva.parent_id)
          eva_par_id.push eva.parent_id
        end
      end
    end
    eva_par_id.each do |j|
      grade_lists.each do |k|
        eva = Evaluation.where(id: k.evaluations_id).first
        if eva == nil
          next
        else 
          if !(eva_id.include? eva.id)
            if Evaluation.where(id:k.evaluations_id).first.parent_id == j
              if Weight.where(evaluations_id:k.evaluations_id).where(status: 1).where(courses_id:course_id).first != nil 
                we += Weight.where(evaluations_id:k.evaluations_id).where(status: 1).where(courses_id:course_id).first.weight.to_f
                eva_id.push eva.id
              end
            end
          end
        end
      end
      eva_id = []
      eva_we.push we
      we = 0
    end
    indx = 0
    eva_par_id.each do |i|
      b[:parent_id] = i
      b[:weight] = eva_we[indx]
      indx += 1
      evaluations_weight.push b
      b = {}
    end






    #course_eva.each do |t|
      
    #  eva = Evaluation.where(id: t.evaluation_id).first
      
    #  if eva == nil
    #    flag = 1
    #    next
    #  else
    #    if !(parents_flag.include? eva.parent_id)
    #      b[:parent_id]= eva.parent_id
    #     b[:weight] = 0
    #     parents_flag.push eva.parent_id
          
          #course_eva.each do |z|
            #uuu.push z.evaluation_id
           # eva2 = Evaluation.where(id: z.evaluation_id).first
          #
          #  if eva2 == nil
          #    next
          #  else
          #    if Weight.where(evaluations_id:z.evaluation_id).first != nil 
          #      eva3 = Evaluation.where(id: z.evaluation_id)
          #      if eva3 != nil
          #        if Evaluation.where(id: z.evaluation_id).first.parent_id == eva.parent_id
          #          b[:weight] += Weight.where(evaluations_id:z.evaluation_id).first.weight.to_f
          #        end
          #      end
          #    end
         #   end
        #  end
       #   evaluations_weight.push b
      #    b = {}
      #  end
      # evaluations_id_falg_.push Evaluation.where(id: t.evaluation_id).first.parent_id
      #end
    #end
    student_score_midle = []
    student_score_end = []
    sco = 0
    c = {}
    test_=[]
    s_id = ''
    grade_sco = 0
    students_list.each do |i|
      b[:name] = i.name
      b[:sno] = i.sno
      b[:class_room] = ClassRoom.where(id:class_room_id).first.name
      b[:course] = Course.where(id:course_id).first.name
      student_grade_list = Grade.where(students_id: i.id).where(courses_id: course_id).where(class_rooms_id:class_room_id).select(:evaluations_id,:students_id,:grade)
      evaluations_weight.each do |k|
        c[:parent_id_c] = k[:parent_id]
        student_grade_list.each do |j|
          if Evaluation.where(id: j.evaluations_id).first !=nil
            if Evaluation.where(id: j.evaluations_id).first.parent_id == k[:parent_id]
              puts '+++++++++++++++++++++++++++grade'
              puts j.grade
              
                test_.push j.grade
                test_.push Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight
              if j.grade == 'Excellent'
                 s_id = j.students_id

                 sco += 100*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                 puts 'ininininininini------------------'
                 test_.push 100*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
              end
              puts grade_sco
              if j.grade == 'Good'
                puts 'goodgoodgood'
                 s_id = j.students_id
                 sco += 90*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                 test_.push 90*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
              end
              if j.grade == 'Average'
                puts 'aveaveave'
                 s_id = j.students_id
                 sco += 80*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                 test_.push 80*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
              end
              if j.grade == 'Fair'
                s_id = j.students_id
                 sco += 70*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                 test_.push 70*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
              end
              if j.grade == 'Poor'
                 s_id = j.students_id
                sco += 60*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                test_.push 60*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f

              end
              if j.grade == 'Fail'
                 s_id = j.students_id
                 sco += 50*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                 test_.push 50*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f

              end
              
              if  j.grade.to_f <= 10 && j.grade.length < 4
                 s_id = j.students_id
                 sco += (j.grade.to_f*10)*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                  test_.push (j.grade.to_f*10)*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
              end
              if j.grade.to_f > 10 && j.grade.length < 4
                 s_id = j.students_id
                 sco += j.grade.to_f*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
                test_.push j.grade.to_f*Weight.where(evaluations_id:j.evaluations_id).where(courses_id:course_id).first.weight.to_f
              end
            end
              puts ' _____________________'
              puts sco
            end
         
        end
        puts '############kkkk'
        puts k['weight']
        puts sco
        c[:we] = k[:weight]
        c[:sc] = sco
        c[:id_s] = s_id
        c[:score]=sco/k[:weight]
        student_score_midle.push c
        c={}
        sco = 0
        grade_sco = 0
        s_id = ''
      end
      all_weight = 0
      all_sco = 0
      puts '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
      puts student_score_midle
      puts '^^^^^^^^^^^^^^^^'
      student_score_midle.each do |l|
       all_weight += Weight.where(evaluations_id:l[:parent_id_c]).where(courses_id:course_id).where(status: 1).first.weight.to_f
       all_sco += l[:score]*Weight.where(evaluations_id:l[:parent_id_c]).where(courses_id:course_id).where(status: 1).first.weight.to_f
      end
     puts '###################'
     puts all_sco
     puts all_weight
     b[:score]=all_sco/all_weight
     student_score_end.push b
     b = {}
     student_score_midle =[]
    end
    
    render json: {'a': student_score_end,'b': evaluations_weight,'e': uuu,'f': parents,'i': eva_we,'j': eva_par_id}
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

end
