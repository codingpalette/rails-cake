class BakeriesController < ApplicationController
  require_admin_access only: [:new, :create]
  allow_unauthenticated_access only: [:show]
  
  def show
    @bakery = Bakery.find(params[:id])
    @menu_items = @bakery.menu_items if @bakery.respond_to?(:menu_items)
  end

  def new
    @bakery = Bakery.new
  end

  def create
    @bakery = Bakery.new(bakery_params)
    @bakery.operating_hours = process_operating_hours

    if @bakery.save
      upload_cloudflare_images
      redirect_to root_path, notice: "가게 등록이 완료되었습니다!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def upload_cloudflare_images
    return unless params[:bakery][:cloudflare_images].present?

    files = params[:bakery][:cloudflare_images].reject(&:blank?)
    @bakery.upload_images(files) if files.any?
  end

  def bakery_params
    params.require(:bakery).permit(
      :name, :category, :phone, :description,
      :postcode, :road_address, :jibun_address, :detail_address, :extra_address
    )
  end

  def process_operating_hours
    return {} unless params[:operating_hours].present?
    
    hours_data = {}
    %w[monday tuesday wednesday thursday friday saturday sunday].each do |day|
      day_params = params[:operating_hours][day]
      next unless day_params
      
      hours_data[day] = {
        "closed" => day_params[:closed] == "1",
        "open_time" => day_params[:open_time],
        "close_time" => day_params[:close_time],
        "last_order" => day_params[:last_order]
      }
    end
    hours_data
  end
end
