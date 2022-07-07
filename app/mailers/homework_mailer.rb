class HomeworkMailer < ApplicationMailer
  default from: 'admin@cheko.com'

  def notify_admin
    @homework = params[:homework]
    mail(to: "bret.encienzo.28@gmail.com", subject: 'New Order')
  end

  def notify_user
    @homework = params[:homework]
    mail(to: @homework.user.email, subject: 'New Order')
  end
end
