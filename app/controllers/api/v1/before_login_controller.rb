class Api::V1::BeforeLoginController < ActionController::API

  def reset_password
  	user = User.find_by(email:params.require(:params)[:email])
    if user==nil||user.username != params.require(:params)[:name]
      render json: { msg: '重置密码失败，学(工)号与姓名不匹配!' }
    else
      user.update(password:params.require(:params)[:email])
      render json: { msg: '密码重置成功!' }
    end
  end

end