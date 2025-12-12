class Admin::BakeriesController < Admin::AdminController
  before_action :set_bakery, only: [ :edit, :update, :destroy ]

  def index
    @bakeries = Bakery.order(created_at: :desc, id: :desc)
  end

  def edit
    # 베이커리 수정 폼
  end

  def update
    @bakery.operating_hours = process_operating_hours
    if @bakery.update(bakery_params)
      upload_cloudflare_images
      redirect_to admin_bakeries_path, notice: "베이커리가 성공적으로 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bakery.delete_all_images
    @bakery.destroy
    redirect_to admin_bakeries_path, notice: "베이커리가 삭제되었습니다."
  end

  private

  def set_bakery
    @bakery = Bakery.find(params[:id])
  end

  def upload_cloudflare_images
    return unless params[:bakery][:cloudflare_images].present?

    files = params[:bakery][:cloudflare_images].reject(&:blank?)
    @bakery.upload_images(files) if files.any?
  end

  def bakery_params
    params.require(:bakery).permit(
      :name, :category, :phone, :description,
      :postcode, :road_address, :jibun_address, :detail_address, :extra_address,
      :store_type, :parent_id
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
