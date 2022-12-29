class Admins::QnasController < ApplicationController
  before_action :authenticate_admin!

  def index
    @qnas = Qna.where("status = 0 OR status = 1")
  end

  def show
    @qna = Qna.find(params[:id])

    if @qna_tutor_id.present?
      @tutor = Tutor.find(@qna.tutor_id)
    end
    
  end

  def finish
    @qna = Qna.find(params[:qna_id])
    @qna.update(status: "done", auth: "finish")
    redirect_to admins_qnas_path
  end
end
