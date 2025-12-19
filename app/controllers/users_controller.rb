class UsersController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      upload_cloudflare_profile_image
      redirect_to edit_user_path, notice: "프로필이 성공적으로 업데이트되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
    redirect_to login_path, alert: "로그인이 필요합니다." unless @user
  end

  def upload_cloudflare_profile_image
    return unless params[:user][:cloudflare_profile_image].present?

    @user.upload_profile_image(params[:user][:cloudflare_profile_image])
  end

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :nickname)
  end
end