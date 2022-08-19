class UserMailer < ApplicationMailer

  def reset_password_email(user)
    @user = User.find user.id
    
    @token  = @user.reset_password_token
    mail(
      to: user.email,
      subject: 'パスワードリセット'
    )
  end
end
