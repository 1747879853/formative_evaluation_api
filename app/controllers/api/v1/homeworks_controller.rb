class Api::V1::HomeworksController < Api::V1::BaseController
  
  def get_hw_eva
    term = params[:term]
    t_id = current_user.owner_id
    c = TeachersClassesCourse.where(term: term,teachers_id:t_id).select(:courses_id).group(:courses_id)
    courses_id = []
    c.each do |i|
      courses_id.push(i.courses_id)
    end
    courses = Course.where(id:courses_id)
    data = []
    courses.each do |i|
      a = {}
      sta = 1
      st = TeachersClassesCourse.where(teachers_id:t_id,courses_id:i.id,term:term).select(:status)
      st.each do |j|
        if j.status !=2
          sta = 0
          break
        end
      end

      if sta==0
        e = i.evaluations.where(types:'text-score')
      else
        ee = Grade.where(term:term,courses_id:i.id).select(:evaluations_id).group(:evaluations_id)
        eee = []
        ee.each do |j|
          eee.push(j.evaluations_id)
        end
        e = Evaluation.where(id:eee,types:'text-score')
      end

      
      if e.length>0
        a["id"]=i.id
        a["name"]=i.name
        a["homework"]=[]
        # a["class"]=[]

        b = {}
        e.each do |j|
          b["id"]=j.id
          b["name"]=j.name
          b["types"]=j.types
          if TeaHomework.where(teachers_id:t_id,courses_id:i.id,term:term,evaluations_id:j.id).length>0
            b["assign"]=1
          else
            b["assign"]=0
          end
          
          a["homework"].push(b.as_json)
        end

        # cc = {}
        # classes_id = []
        # class_id = TeachersClassesCourse.where(term: term,teachers_id:t_id,courses_id:i.id).select(:class_rooms_id).group(:class_rooms_id)
        # class_id.each do |j|
        #   classes_id.push(j.class_rooms_id)
        # end
        # classes = ClassRoom.where(id:classes_id)
        # classes.each do |j|
        #   cc["id"]=j.id
        #   cc["name"]=j.name
        #   cc["homework"]=a["homework"]
        #   a["class"].push(cc.as_json)
        # end

        data.push(a.as_json)
      end
    end
    render json: data
  end

  def post_hw_eva
    t_id = current_user.owner_id
    term = params.require(:params)[:term]
    course_id = params.require(:params)[:courses_id]
    eval_id = params.require(:params)[:eval_id]
    homework = params.require(:params)[:homework]
    if homework=='get'
      t = TeaHomework.where(teachers_id:t_id,courses_id:course_id,term:term,evaluations_id:eval_id)
      render json: {'a': t[0],'b': t[0].start_time > Time.now ? true : false}
    else
      t = TeaHomework.create({teachers_id:t_id,courses_id:course_id,term:term,evaluations_id:eval_id,name:homework["name"],demand:homework["demand"],start_time:homework["start_time"],end_time:homework["end_time"]})
      render json: {'a': t,'b': t.start_time > Time.now ? true : false}
    end
  end

  def patch_hw_eva
    t_id = current_user.owner_id
    term = params.require(:params)[:term]
    course_id = params.require(:params)[:courses_id]
    eval_id = params.require(:params)[:eval_id]
    homework = params.require(:params)[:homework]

    t = TeaHomework.where(teachers_id:t_id,courses_id:course_id,term:term,evaluations_id:eval_id)
    t.update(name:homework["name"],demand:homework["demand"],start_time:homework["start_time"],end_time:homework["end_time"])
    render json: {'a': t[0],'b': t[0].start_time > Time.now ? true : false}
  end

  def get_hw
    type = current_user.owner_type
    u = current_user.owner    
    term = params[:term]
    if type =='Student'
      cr = u.class_room
      c_id = TeachersClassesCourse.where(class_rooms_id:cr.id,term:term).select(:courses_id).group(:courses_id)
      c = []
      c_id.each do |i|
        c.push(Course.find(i.courses_id))
      end

      data = []
      c.each do |i|
        a = {}
        t = TeachersClassesCourse.where(class_rooms_id:cr.id,term:term,courses_id:i.id).select(:teachers_id)

        # e = i.evaluations.where(types:'homework')

        sta = 1
        st = TeachersClassesCourse.where(teachers_id:t[0].teachers_id,courses_id:i.id,term:term).select(:status)
        st.each do |j|
          if j.status !=2
            sta = 0
            break
          end
        end

        if sta==0
          e = i.evaluations.where(types:'text-score')
        else
          ee = Grade.where(term:term,courses_id:i.id).select(:evaluations_id).group(:evaluations_id)
          eee = []
          ee.each do |j|
            eee.push(j.evaluations_id)
          end
          e = Evaluation.where(id:eee,types:'text-score')
        end


        if e.length>0
          a["id"]=i.id
          a["name"]=i.name
          a["homework"]=[]

          b = {}
          e.each do |j|
            b["id"]=j.id
            b["name"]=j.name
            b["types"]=j.types
            b["homework"]=[]
            b["done"]=0
            h = TeaHomework.where(teachers_id:t[0].teachers_id,courses_id:i.id,term:term,evaluations_id:j.id)
            
            if h.length>0&&h[0].start_time>Time.now
              # b["homework"].push(h[0].as_json)
              # b["done"]=0
              # a["homework"].push(b.as_json)
            elsif h.length>0&&h[0].start_time<Time.now&&h[0].end_time>Time.now
              b["homework"].push(h[0].as_json)
              sh = StuHomework.where(tea_homeworks_id:h[0].id,students_id:u.id)
              if sh.length>0
                b["done"]=2  
                b["homework"].push(sh[0].as_json)
              else
                b["done"]=1
              end
              a["homework"].push(b.as_json)
            elsif h.length>0&&h[0].end_time<Time.now
              b["homework"].push(h[0].as_json)
              sh = StuHomework.where(tea_homeworks_id:h[0].id,students_id:u.id)
              if sh.length>0
                b["homework"].push(sh[0].as_json)
              end
              b["done"]=3
              a["homework"].push(b.as_json)
            end

          end

          data.push(a.as_json)
        end
      end
      render json: { 'a': u, 'b': cr, 'c': data }
    else
      render json: { 'a': u }
    end
    
  end

  def post_hw
    s_id = current_user.owner_id
    content = params.require(:params)[:content]
    th_id = params.require(:params)[:th_id]
    if content=='get'
      render json: StuHomework.where(students_id:s_id,tea_homeworks_id:th_id)
    else
      s = StuHomework.create({students_id:s_id,tea_homeworks_id:th_id,finish_time:Time.now,content:content})
      render json: s
    end
  end

  def patch_hw
    s_id = current_user.owner_id
    content = params.require(:params)[:content]
    th_id = params.require(:params)[:th_id]

    s = StuHomework.where(students_id:s_id,tea_homeworks_id:th_id)
    s.update(finish_time:Time.now,content:content)
    render json: s
  end

  def get_hw_by_id
    t_id = current_user.owner_id
    course_id = params[:courses_id]
    term = params[:term]
    eva_id = params[:eval]
    stu_id = params[:stu_id]

    th = TeaHomework.where(teachers_id:t_id,courses_id:course_id,term:term,evaluations_id:eva_id)
    if th.length>0
      th_id = th[0].id
      sh = StuHomework.where(students_id:stu_id,tea_homeworks_id:th_id).select(:finish_time,:content)
      if sh.length>0
        render json: sh[0]
      else
        render json: {'finish_time': '未能按时完成','content': ''}
      end
      
    else
      render json: {'finish_time': '尚未完成','content': ''}
    end

    
  end

end
