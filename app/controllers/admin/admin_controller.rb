class Admin::AdminController < ApplicationController
  require_admin_access

  def dashboard
    @users_count = User.count
    @admin_users_count = User.where(admin: true).count
    @regular_users_count = User.where(admin: false).count

    puts("user1111111", @users_count)
  end

  def users
    @users = User.all.order(:email_address)
    # puts("users222222222", @users.inspect)
  end

  def toggle_admin
    user = User.find(params[:id])

    if user.admin?
      user.remove_admin!
      message = "#{user.email_address}의 관리자 권한을 제거했습니다."
    else
      user.make_admin!
      message = "#{user.email_address}을 관리자로 설정했습니다."
    end

    redirect_to admin_users_path, notice: message
  end
end
