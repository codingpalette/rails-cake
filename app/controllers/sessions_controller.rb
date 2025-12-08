class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "안녕하세요! 로그인되었습니다."
    else
      redirect_to new_session_path(email_address: params[:email_address]), alert: "이메일 주소 또는 비밀번호가 올바르지 않습니다."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "로그아웃되었습니다."
  end
end
