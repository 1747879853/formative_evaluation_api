class Api::V1::EmployeeController < Api::V1::BaseController

  def get_attendanceList

    begin
      emp = LocalTimeRecord.joins([employee: :local_depart_record]).select("local_time_records.sign_time, employees.name, employees.workno, local_depart_records.depart_name").order("local_time_records.sign_time desc")
        render json: emp
    rescue Exception => e
      render json: { msg: e }, status: 500
    end

  end

  def post_attendanceList

    begin
      s = params.require(:params)[:s_time]
      e = params.require(:params)[:e_time] 
      na = params.require(:params)[:empname]
      emp = LocalTimeRecord.joins([employee: :local_depart_record]).select("local_time_records.sign_time, employees.name, employees.workno, local_depart_records.depart_name").where("employees.name like ? and local_time_records.sign_time between '#{s}' and '#{e}'",['%',na, '%'].join).order("local_time_records.sign_time desc")
        render json: emp
    rescue Exception => e
      render json: { msg: e }, status: 500
    end

  end

end