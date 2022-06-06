class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @history = Homework.where(status: "done").order(created_at: :asc)
    @pending = current_admin.role == "admin" ? Homework.where(status: "reviewing", admin_id: current_admin.id) : Homework.where(status: "reviewing") 
    @ongoing = Homework.where(status: "ongoing")
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
  end

  def destroy
    @homework.destroy!
    redirect_to admins_homeworks_path
  end

  def edit
    @leads = Admin.all
    @managers = Manager.all
    @tutors = Tutor.all
  end

  def update
    if current_admin.role == "super_admin"
      work = @homework.update(admin_id: params[:homework][:admin_id], manager_id: params[:homework][:manager_id], tutor_id: params[:homework][:tutor_id])
    else
      work = @homework.update(manager_id: params[:homework][:manager_id], tutor_id: params[:homework][:tutor_id])
    end

    if work && @homework.admin_id.present? && @homework.status == "reviewing"
      @homework.accept_order
    end

    # if work && @homework.tutor_id.present? 
      
    #   @homework.
    # end
    redirect_to admins_homeworks_path
  end

  def assign
    @homework.update(admin_id: current_admin.id)
    redirect_to admins_homeworks_path
  end

  def assign_tutor
    bid = Bid.find(params[:bid_id])
    @homework.assign_tutor(bid)
    #.update(tutor_id: params[:tutor_id])
    redirect_to admins_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
