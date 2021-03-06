class Api::V1::HomePageController < Api::V1::BaseController
  
  def show_histo    
    ags = current_user.auth_groups.map(&:title)
    if (ags.include? '开发者') || (ags.include? '超级管理员')
      render json: {show: true}
    else
      render json: {show: false}
    end
    
  end

  def classroom_question_chart
    #final_list = []
    # teacher_list = []
    # class_room_questions_list = []
    # rq = Evaluation.where(types:'classroom_question').select(:id)
    # rq.each do |i|
    #   g = Grade.where(evaluations_id:i.id,record_time:(Time.now - 7.day)..Time.now).select(:class_rooms_id,:courses_id,:term)
    #   g.each do |j|
    #     teacher_id = TeachersClassesCourse.where(class_rooms_id:j.class_rooms_id,courses_id:j.courses_id,term:j.term).select(:teachers_id)
    #     teacher_list.push(Teacher.where(id:teacher_id[0].teachers_id).select(:name,:tno)[0].name)
    #   end
    # end

    # render json: teacher_list.group_by{|x| x}.map{|k,v| [k,v.count] }


    t=Time.now
    current_term = Term.where('begin_time < ?',t).where('end_time > ?', t).first
    if current_term==nil
      render json: {'a': 0}
    else
      d = Date.today
      end_datetime = (d-d.wday).to_datetime.end_of_day
      start_datetime = (d-d.wday-6).to_datetime.beginning_of_day

      name_times = Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id").where(term: current_term.id).where(record_time: start_datetime..end_datetime).where("evaluations.types = 'classroom_question' ").group('teachers.name').count
      re =[]
      t = {}
      name_times.each do |e|
        t['name'] = e[0]
        t['times'] = e[1]
        re.push t  
        t={}   

      end
      render json: {'a': 1,'b': re}
    end
    
  end

  def get_teacher_course_list
    render json: {'a': Teacher.all,'b': Course.all,'c': ClassRoom.all,'d':Term.all } 
  end

 

  def get_details_histogram
    checked_teachers = params[:checked_teachers]
    checked_courses = params[:checked_courses]
    t=Time.now
    current_term = Term.where('begin_time < ?',t).where('end_time > ?', t).first
    time = params[:time]
    d = {}
    res = []
    times = []
    checked_courses.each do |j|
        courses_id = Course.select(:id).where(name:j)
        
        times = Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id").where(term: current_term.id).where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").where(courses_id:courses_id).group('teachers.name').count
       
      end
    checked_teachers.each do |i|
      d['name'] = i
      #res.push i
      t = 0
      times.each do |k|
        if(k[0]==i)
          t+=k[1]
        end
      end
      d['times'] = t
      res.push d
      d = {}
    end
    render json: res
  end

  def get_detailed_teacher_histogram
    time = params[:time]
    name_times =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").group('teachers.name').count
    re =[]
    t = {}
    name_times.each do |e|
      t['name'] = e[0]
      t['times'] = e[1]
      re.push t  
      t={}   

    end
    render json: re
  end

  def get_teacher_charts
    time = params[:time]
    checked_teacher = params[:checked_teacher]
    teacher_id = Teacher.select(:id).where(name:checked_teacher).first.id
    name_times_class_rooms =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id and teachers.id = #{teacher_id} inner join class_rooms on grades.class_rooms_id = class_rooms.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").group('class_rooms.name').count
    name_times_courses =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id and teachers.id = #{teacher_id} inner join courses on grades.courses_id = courses.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").group('courses.name').count
    re1 =[]
    re2 =[]
    t = {}
    name_times_class_rooms.each do |e|
      t['name'] = e[0]
      t['times'] = e[1]
      re1.push t  
      t={}   
    end
    t = {}
    name_times_courses.each do |i|
      t['name'] = i[0]
      t['times'] = i[1]
      re2.push t  
      t={}   
    end
    render  json: {'a': re1,'b': re2}
  end

  def get_detailed_class_room_histogram
    time = params[:time]
    name_times_class_rooms =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join class_rooms on grades.class_rooms_id = class_rooms.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").group('class_rooms.name').count
    re1 =[]
    t = {}
    name_times_class_rooms.each do |e|
      t['name'] = e[0]
      t['times'] = e[1]
      re1.push t  
      t={}   
    end
    render json: re1
  end

  def get_class_room_charts
    time = params[:time]
    checked_class_room = params[:checked_class_room]
    class_room_id = ClassRoom.select(:id).where(name:checked_class_room).first.id
    name_times_teachers =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join class_rooms on grades.class_rooms_id = class_rooms.id").where(record_time: time[0]..time[1]).where(class_rooms_id: class_room_id).where("evaluations.types = 'classroom_question' ").group('teachers.name').count
    name_times_courses =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join courses on grades.courses_id = courses.id").where(record_time: time[0]..time[1]).where(class_rooms_id:class_room_id).where("evaluations.types = 'classroom_question' ").group('courses.name').count
    re1 =[]
    re2 =[]
    t = {}
    name_times_teachers.each do |e|
      t['name'] = e[0]
      t['times'] = e[1]
      re1.push t  
      t={}   
    end
    t = {}
    name_times_courses.each do |i|
      t['name'] = i[0]
      t['times'] = i[1]
      re2.push t  
      t={}   
    end
    render  json: {'a': re1,'c': re2}
  end

  def get_detailed_class__histogram
    time = params[:time]
    name_times_courses =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join courses on grades.courses_id = courses.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").group('courses.name').count
    re1 =[]
    t = {}
    name_times_courses.each do |e|
      t['name'] = e[0]
      t['times'] = e[1]
      re1.push t  
      t={}   
    end
    render json: re1
  end

  def get_course_charts
    time = params[:time]
    checked_course = params[:checked_course]
    course_id = Course.select(:id).where(name:checked_course).first.id
    name_times_class_rooms =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join class_rooms on grades.class_rooms_id = class_rooms.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").where(courses_id:course_id).group('teachers.name').count
    name_times_courses =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join courses on grades.courses_id = courses.id inner join class_rooms on grades.class_rooms_id = class_rooms.id").where(record_time: time[0]..time[1]).where("evaluations.types = 'classroom_question' ").where(courses_id:course_id).group('class_rooms.name').count
    re1 =[]
    re2 =[]
    t = {}
    name_times_class_rooms.each do |e|
      t['name'] = e[0]
      t['times'] = e[1]
      re1.push t  
      t={}   
    end
    t = {}
    name_times_courses.each do |i|
      t['name'] = i[0]
      t['times'] = i[1]
      re2.push t  
      t={}   
    end
    render  json: {'a': re1,'b': re2}
  end

  def get_teacher_line
    checked_teachers = params[:checked_teachers]
    term_id = params[:term_id]

    #t = Term.where("name is not null").all
    
    t = Term.where(id:term_id).first
    now = Time.now
    begin_time = Time.now
    end_time = Time.now
   
      if t.begin_time<now&&t.end_time>now
         begin_time = t.begin_time
         end_time = Time.now
      else
        begin_time = t.begin_time
        end_time = t.end_time
      end
    
    weeks = []
    time_weeks ={}
    time_end = Time.new -1
    time_begin = Time.new -1
    m = 1
    while time_end < end_time do 
      time_weeks['begin_time'] = begin_time
      time_weeks['end_time'] = begin_time + 6
      time_weeks['weeks'] = "第#{m}学周"
      time_weeks['max'] = m
      m = m+1
      weeks.push time_weeks
      time_end = begin_time + 6
      begin_time = begin_time + 7
      time_weeks = {}
    end
    res1 =[]
    t ={}
    res = nil
    checked_teachers.each do |i|
      data = []
      weeks.each do |j|
        name_times =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id and teachers.name = '#{i}'").where(record_time: j['begin_time']...j['end_time']+1).where("evaluations.types = 'classroom_question' ").group('teachers.name').count
        
        name_times.each do |k|
          t['name'] = k[0]
          t['times'] = k[1]
          t['week'] = j['weeks']
          t['max'] = j['max']
          data.push t
          t = {}
        end
      end
      if data == []
        t['name'] = i
        t['times'] = 0
        t['week'] = ''
        t['max'] = 0
        data.push t
        t = {} 
      end
      res1.push data
        data = []
     
    end
    
    render json: {'b': begin_time ,'a': end_time, 'c': weeks,'d': res1}
  end

  def get_course_line
    checked_course = params[:checked_course]
    term_id = params[:term_id]

    #t = Term.where("name is not null").all
    
    t = Term.where(id:term_id).first
    now = Time.now
    begin_time = Time.now
    end_time = Time.now
   
      if t.begin_time<now&&t.end_time>now
         begin_time = t.begin_time
         end_time = Time.now
      else
        begin_time = t.begin_time
        end_time = t.end_time
      end
    
    weeks = []
    time_weeks ={}
    time_end = Time.new -1
    time_begin = Time.new -1
    m = 1
    while time_end < end_time do 
      time_weeks['begin_time'] = begin_time
      time_weeks['end_time'] = begin_time + 6
      time_weeks['weeks'] = "第#{m}学周"
      time_weeks['max'] = m
      m = m+1
      weeks.push time_weeks
      time_end = begin_time + 6
      begin_time = begin_time + 7
      time_weeks = {}
    end
    res1 =[]
    t ={}
    res = nil
    checked_course.each do |i|
      data = []
      weeks.each do |j|
        course_id = Course.select(:id).where(name:i).first.id
        name_times =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join courses on courses.id = grades.courses_id").where(record_time: j['begin_time']...j['end_time']+1).where("evaluations.types = 'classroom_question' ").where(courses_id:course_id).group('courses.name').count
        
        name_times.each do |k|
          t['name'] = k[0]
          t['times'] = k[1]
          t['week'] = j['weeks']
          t['max'] = j['max']
          data.push t
          t = {}
        end
      end
      if data == []
        t['name'] = i
        t['times'] = 0
        t['week'] = ''
        t['max'] = 0
        data.push t
        t = {} 
      end
      res1.push data
        data = []
     
    end
    
    render json: {'b': begin_time ,'a': end_time, 'c': weeks,'d': res1}
  end

  def get_class_room_line
    checked_class_room = params[:checked_class_room]
    term_id = params[:term_id]

    #t = Term.where("name is not null").all
    
    t = Term.where(id:term_id).first
    now = Time.now
    begin_time = Time.now
    end_time = Time.now
   
      if t.begin_time<now&&t.end_time>now
         begin_time = t.begin_time
         end_time = Time.now
      else
        begin_time = t.begin_time
        end_time = t.end_time
      end
    
    weeks = []
    time_weeks ={}
    time_end = Time.new -1
    time_begin = Time.new -1
    m = 1
    while time_end < end_time do 
      time_weeks['begin_time'] = begin_time
      time_weeks['end_time'] = begin_time + 6
      time_weeks['weeks'] = "第#{m}学周"
      time_weeks['max'] = m
      m = m+1
      weeks.push time_weeks
      time_end = begin_time + 6
      begin_time = begin_time + 7
      time_weeks = {}
    end
    res1 =[]
    t ={}
    res = nil
    checked_class_room.each do |i|
      data = []
      weeks.each do |j|
         class_room_id = ClassRoom.select(:id).where(name:i).first.id
        name_times =Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id inner join class_rooms on grades.class_rooms_id = class_rooms.id").where(record_time: j['begin_time']...j['end_time']+1).where("evaluations.types = 'classroom_question' ").where(class_rooms_id:class_room_id).group('class_rooms.name').count
        
        name_times.each do |k|
          t['name'] = k[0]
          t['times'] = k[1]
          t['week'] = j['weeks']
          t['max'] = j['max']
          data.push t
          t = {}
        end
      end
      if data == []
        t['name'] = i
        t['times'] = 0
        t['week'] = ''
        t['max'] = 0
        data.push t
        t = {} 
      end
      res1.push data
        data = []
     
    end
    
    render json: {'b': begin_time ,'a': end_time, 'c': weeks,'d': res1}
  end


end
