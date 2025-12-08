class AdminSetupController < ApplicationController
  # 관리자 설정 페이지는 인증 없이 접근 가능 (최초 관리자 생성 시)
  allow_unauthenticated_access only: %i[ new create ]
  
  # 이미 관리자가 있으면 접근 차단
  before_action :redirect_if_admin_exists
  
  # GET /admin_setup/new
  # 최초 관리자 생성 폼
  def new
    @user = User.new
  end
  
  # POST /admin_setup
  # 최초 관리자 생성 처리
  def create
    @user = User.new(admin_params)
    @user.admin = true # 관리자 권한 부여
    
    if @user.save
      # 자동 로그인 처리
      start_new_session_for @user
      redirect_to admin_root_path, notice: "최초 관리자 계정이 생성되었습니다! 이제 케이크몰 관리를 시작할 수 있습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  # 이미 관리자가 존재하면 홈으로 리다이렉트
  def redirect_if_admin_exists
    if User.where(admin: true).exists?
      redirect_to root_path, alert: "이미 관리자가 존재합니다."
    end
  end
  
  def admin_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end