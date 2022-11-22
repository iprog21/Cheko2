class Users::HomeworksController < Users::UserAppController
  before_action :authenticate_user!
  before_action :find_homework, except: [:index, :create, :new, :pick_type]
  
  def index
    # @pending = current_user.homeworks.where(status: "reviewing")
    # @ongoing = current_user.homeworks.where(status: "ongoing")
    # @history = current_user.homeworks.where(status: "done")
    @homeworks = current_user.homeworks
  end

  def show
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
  end

  def new
    @homework = current_user.homeworks.new
  end

  def create
    @admin = Admin::where(status: 1).first
    @homework = current_user.homeworks.new(homework_params)

    if @homework.save
      #HomeworkMailer.with(homework: @homework).notify_admin.deliver_now
     
      #assign admin_id
      @homework.update(admin_id: @admin.id)

      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Admin")

      #send email all tutors that new homework is up for bidding
      tutors = Tutor.all 
      tutors.each do |tutor|
        NotifyTutorJob.set(wait: 2.seconds).perform_later("new_order", tutor)
      end


      redirect_to users_homeworks_path
    else
      render 'new'
    end
  end

  def success
    unless @homework.user_id == current_user.id
      redirect_to users_homeworks_path
    end
  end

  def edit
  end

  def update
    if @homework.update!(homework_params)
      redirect_to users_homeworks_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end

  def homework_params
    deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
    params.require(:homework).permit(:hw_attachment, :details, :payment_type, :subject, :sub_subject, :budget, :tutor_skills, :tutor_samples, :sub_type, :priority, :view_bidders, :login_school, :budget, :order_type, :words, :tutor_category).merge(deadline: deadline)
  end
end
