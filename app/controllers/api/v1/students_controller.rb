class Api::V1::StudentsController < Api::V1::BaseController
  
  def get_studentlist
    render json: {'a': Student.joins(:class_room).select("students.id,students.name,students.year,students.email,students.sno,students.tel,students.status,students.class_room_id,class_rooms.name classname").where(status: 1),'b': ClassRoom.select("id,name").where(status: 1)}
  end

  def post_studentlist
    begin
      student = Student.new(student_params)
      if student.save!
        user = User.new
        user.password='password'
        user.owner = student
        user.username = student.name
        user.email = student.email
        user.tel = student.tel
        user.save!
        render json: Student.joins(:class_room).select("students.id,students.name,students.year,students.email,students.sno,students.tel,students.status,students.class_room_id,class_rooms.name classname").where(id: student.id)
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_studentlist
    begin
      student_id = params.require(:params)[:id]
      student = Student.find(student_id)
      if student.update(student_params)
        user_id = User.where(owner_id: student_id).where("owner_type='Student'").ids
        user = User.find(user_id[0])
        user.username = student.name
        user.email = student.email
        user.tel = student.tel
        user.save!
        render json: Student.joins(:class_room).select("students.id,students.name,students.year,students.email,students.sno,students.tel,students.status,students.class_room_id,class_rooms.name classname").where(id: student.id)
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def delete_studentlist
    begin
      student_id = params.require(:params)[:id]
      student = Student.find(student_id)
      if student.update(params.require(:params).permit(:status))
        user_id = User.where(owner_id: student_id).where("owner_type='Student'").ids
        user = User.find(user_id[0])
        user.destroy
        render json: { }
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def post_manystudent
    begin
      studentList = params.require(:params)[:data]
      studentList.length.times do |i|
        studentList[i]["class_room_id"]=params.require(:params)[:class_room_id]
        student = Student.new(studentList[i].permit(:name, :email, :tel, :year, :status, :sno, :class_room_id))
        if student.save!
          user = User.new
          user.password='password'
          user.owner = student
          user.username = student.name
          user.email = student.email
          user.tel = student.tel
          user.save!
        end
      end
      render json: Student.joins(:class_room).select("students.id,students.name,students.year,students.email,students.sno,students.tel,students.status,students.class_room_id,class_rooms.name classname").where(status: 1)
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def get_classstu
    begin
      render json: Student.select("id,name,year,sno,tel,status,email").where(status: 1).where(class_room_id: params.require(:params)[:id]).order("sno")
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def post_classstu
    begin
      student_id = Student.where(sno: params.require(:params)[:stuid]).ids
      student = Student.find(student_id[0])
      if student.update(:class_room_id => params.require(:params)[:id])
        render json: {}
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def delete_classstu
    begin
      student_id = params.require(:params)[:stuid]
      student = Student.find(student_id)
      if student.update(params.require(:params).permit(:status))
        user_id = User.where(owner_id: student_id).where("owner_type='Student'").ids
        user = User.find(user_id[0])
        user.destroy
        render json: Student.select("id,name,year,sno,tel,status,email").where(status: 1).where(class_room_id: params.require(:params)[:id])
      end
    rescue Exception => e
      render json: { msg: e }, status: 500      
    end
  end

  def student_params
    params.require(:params).permit(:name, :email, :tel, :year, :status, :sno, :class_room_id)
  end
end
