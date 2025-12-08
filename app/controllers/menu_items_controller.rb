class MenuItemsController < ApplicationController
  require_admin_access
  before_action :set_bakery

  def create
    @menu_item = @bakery.menu_items.build(menu_item_params)

    if @menu_item.save
      upload_cloudflare_image
      redirect_to @bakery, notice: "메뉴가 추가되었습니다."
    else
      redirect_to @bakery, alert: "메뉴 추가에 실패했습니다."
    end
  end

  def destroy
    @menu_item = @bakery.menu_items.find(params[:id])
    @menu_item.delete_image
    @menu_item.destroy
    redirect_to @bakery, notice: "메뉴가 삭제되었습니다."
  end

  private

  def set_bakery
    @bakery = Bakery.find(params[:bakery_id])
  end

  def upload_cloudflare_image
    return unless params[:menu_item][:cloudflare_image].present?

    @menu_item.upload_image(params[:menu_item][:cloudflare_image])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price)
  end
end