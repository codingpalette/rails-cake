class Bakery < ApplicationRecord
  include CloudflareImageable

  # 매장 유형 상수
  STORE_TYPES = {
    'main' => '본점',
    'branch' => '지점',
    'popup' => '팝업'
  }.freeze

  # 연관관계
  has_many :menu_items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :notes, dependent: :destroy

  # 자기 참조 연관관계 (본점-지점)
  belongs_to :parent, class_name: 'Bakery', optional: true
  has_many :branches, class_name: 'Bakery', foreign_key: 'parent_id', dependent: :nullify

  has_cloudflare_images :images, column: :cloudflare_image_ids

  validates :name, presence: true
  validates :category, presence: true
  validates :road_address, presence: { message: "주소 검색 버튼을 클릭하여 주소를 입력해주세요" }
  validates :phone, presence: true
  validates :store_type, presence: true, inclusion: { in: STORE_TYPES.keys }
  validate :parent_must_be_main_store, if: -> { parent_id.present? }

  # 스코프
  scope :main_stores, -> { where(store_type: 'main') }
  scope :branches_only, -> { where(store_type: 'branch') }
  scope :popups_only, -> { where(store_type: 'popup') }

  # 매장 유형 헬퍼 메서드
  def main?
    store_type == 'main'
  end

  def branch?
    store_type == 'branch'
  end

  def popup?
    store_type == 'popup'
  end

  def store_type_name
    STORE_TYPES[store_type] || store_type
  end

  # 관련 매장 조회 (본점이면 지점들, 지점이면 본점+형제 지점들)
  def related_stores
    if main?
      branches
    elsif parent.present?
      Bakery.where(parent_id: parent_id).or(Bakery.where(id: parent_id)).where.not(id: id)
    else
      Bakery.none
    end
  end

  # 본점 찾기 (자신이 본점이면 자신 반환)
  def main_store
    main? ? self : parent
  end

  # 전체 주소를 조합하는 메서드
  def full_address
    full = road_address.to_s
    full += " #{detail_address}" if detail_address.present?
    full += extra_address if extra_address.present?
    full
  end

  # 기존 address 필드와의 호환성을 위해
  def address
    full_address
  end


  # 운영시간 관련 메서드들
  def operating_hours_data
    return default_operating_hours if operating_hours.blank?
    operating_hours
  end

  def formatted_hours_for_day(day)
    hours = operating_hours_data[day.to_s]
    return "휴무" if hours.blank? || hours["closed"]

    open_time = hours["open_time"]
    close_time = hours["close_time"]
    last_order = hours["last_order"]

    result = "#{open_time} - #{close_time}"
    result += "\n#{last_order} 라스트오더" if last_order.present?
    result
  end

  def today_hours
    day = Date.current.strftime("%A").downcase
    formatted_hours_for_day(day)
  end

  private

  def parent_must_be_main_store
    if parent.present? && !parent.main?
      errors.add(:parent_id, "본점만 상위 매장으로 선택할 수 있습니다")
    end
  end

  def default_operating_hours
    {
      "monday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false },
      "tuesday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false },
      "wednesday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false },
      "thursday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false },
      "friday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false },
      "saturday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false },
      "sunday" => { "open_time" => "12:00", "close_time" => "21:00", "last_order" => "20:30", "closed" => false }
    }
  end
end
