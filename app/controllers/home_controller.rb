class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @bakeries_scope = Bakery.order(created_at: :desc, id: :desc)

    # 검색어가 있으면 필터링
    if params[:query].present?
      @bakeries_scope = @bakeries_scope.where("name LIKE ?", "%#{params[:query]}%")
    end

    @pagy, @bakeries = pagy(:offset, @bakeries_scope, limit: 20)

    # Turbo Frame 요청일 경우 부분 템플릿만 렌더링
    render partial: "bakeries_page", formats: [ :html ], locals: { bakeries: @bakeries, pagy: @pagy } if turbo_frame_request?
  end
end
