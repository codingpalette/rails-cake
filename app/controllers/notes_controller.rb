class NotesController < ApplicationController
  before_action :set_bakery
  before_action :set_note, only: [ :show, :edit, :update, :destroy, :toggle_public ]
  before_action :ensure_favorite, only: [ :new, :create ]

  def index
    @notes = Current.user.notes.where(bakery: @bakery).recent
  end

  def show
    # puts("==== 노트 정보 ====")
    # puts(@note.inspect)  # 또는 아래 방법들 중 선택

    # 더 자세한 정보 출력
    # puts("ID: #{@note.id}")
    # puts("내용: #{@note.content}")
    # puts("방문일: #{@note.visit_date}")
    # puts("가게: #{@note.bakery.name}")
    # puts("작성자: #{@note.user.email_address}")
    # puts("이미지 개수: #{@note.images.count}")
    # puts("생성일: #{@note.created_at}")
    # puts("수정일: #{@note.updated_at}")

    # JSON 형태로 출력
    # puts("JSON 형태:")
    # puts(@note.to_json)

    # 속성만 출력
    # puts("속성들:")
    # puts(@note.attributes)
  end

  def new
    @note = Current.user.notes.build(bakery: @bakery, visit_date: Date.today)
  end

  def create
    @note = Current.user.notes.build(note_params)
    @note.bakery = @bakery

    if @note.save
      upload_cloudflare_images
      redirect_to bakery_notes_path(@bakery), notice: "노트가 성공적으로 저장되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @note.update(note_params)
      upload_cloudflare_images
      redirect_to bakery_note_path(@bakery, @note), notice: "노트가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.delete_all_images
    @note.destroy
    redirect_to bakery_notes_path(@bakery), notice: "노트가 삭제되었습니다."
  end

  def toggle_public
    @note.toggle_public!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "note_public_toggle_#{@note.id}",
          partial: "notes/public_toggle",
          locals: { note: @note }
        )
      end
      format.html { redirect_back(fallback_location: bakery_note_path(@bakery, @note)) }
    end
  end

  private

  def set_bakery
    @bakery = Bakery.find(params[:bakery_id])
  end

  def set_note
    @note = Current.user.notes.find(params[:id])
  end

  def ensure_favorite
    unless Current.user.favorites.exists?(bakery: @bakery)
      redirect_to @bakery, alert: "즐겨찾기한 가게만 노트를 작성할 수 있습니다."
    end
  end

  def upload_cloudflare_images
    return unless params[:note][:cloudflare_images].present?

    files = params[:note][:cloudflare_images].reject(&:blank?)
    @note.upload_images(files) if files.any?
  end

  def note_params
    params.require(:note).permit(:content, :visit_date)
  end
end
