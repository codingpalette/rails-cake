class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @pagy, @bakeries = pagy(:offset, Bakery.order(created_at: :desc, id: :desc), limit: 20)

    # Turbo Frame 요청일 경우 부분 템플릿만 렌더링
    render partial: "bakeries_page", formats: [ :html ], locals: { bakeries: @bakeries, pagy: @pagy } if turbo_frame_request?
  end
end
