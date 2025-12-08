class RegistrationsController < ApplicationController
  # 인증되지 않은 사용자도 회원가입 페이지(new)와 회원가입 처리(create)에 접근 가능하도록 설정
  # 로그인하지 않은 상태에서도 회원가입할 수 있어야 하므로 필수
  allow_unauthenticated_access only: %i[ new create ]
  
  # GET /registrations/new
  # 회원가입 폼을 보여주는 액션
  def new
    # 새로운 User 객체를 생성하여 폼에서 사용
    # 이 객체는 DB에 저장되지 않은 빈 객체
    @user = User.new
  end

  # POST /registrations
  # 실제 회원가입을 처리하는 액션
  def create
    # 사용자가 입력한 정보로 새 User 객체 생성
    # user_params 메서드로 허용된 파라미터만 사용
    @user = User.new(user_params)
    
    # DB에 사용자 정보 저장 시도
    if @user.save
      # 저장 성공 시:
      # 1. 새로 생성한 사용자로 자동 로그인 (세션 생성)
      start_new_session_for @user
      # 2. 홈 페이지로 리다이렉트하며 환영 메시지 표시
      redirect_to root_path, notice: "환영합니다! 회원가입이 완료되었습니다."
    else
      # 저장 실패 시 (유효성 검사 실패 등):
      # 회원가입 폼을 다시 렌더링하고, HTTP 상태 코드 422 반환
      # @user.errors에 에러 정보가 포함되어 뷰에서 표시됨
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters: 보안을 위해 허용할 파라미터만 명시
  # 악의적인 사용자가 admin 같은 속성을 추가로 전송해도 무시됨
  def user_params
    # params에서 :user 키를 필수로 요구하고
    # 그 안에서 email_address, password, password_confirmation만 허용
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
