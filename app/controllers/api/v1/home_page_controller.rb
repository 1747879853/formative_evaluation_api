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
    name_times = Grade.joins("inner join evaluations on grades.evaluations_id = evaluations.id inner join teachers_classes_courses on grades.class_rooms_id = teachers_classes_courses.class_rooms_id and grades.courses_id = teachers_classes_courses.courses_id and grades.term = teachers_classes_courses.term inner join teachers on teachers_classes_courses.teachers_id = teachers.id").where(term: current_term.id).where("evaluations.types = 'classroom_question' ").group('teachers.name').count
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


end
