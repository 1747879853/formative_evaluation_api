class Api::V1::TermsController < Api::V1::BaseController
  
  def get_termlist
    t = Term.where("name is not null").all
    now = Time.now
    option = ''
    t.each do |i|
      if i.begin_time<now&&i.end_time>now
        option = i.id
        break
      end
    end
    render json: { 'a': t,'b': option }
  end

  def post_termlist
    begin
      term = Term.new(term_params)
      if term.save!
        render json: term
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def patch_termlist
    begin
      term_id = params.require(:params)[:id]
      term = Term.find(term_id)
      if term.update(term_params)
        render json: term
      end
    rescue Exception => e
      render json: { msg: e }, status: 500
    end
  end

  def term_params
    params.require(:params).permit(:name, :begin_time, :end_time)
  end

end
