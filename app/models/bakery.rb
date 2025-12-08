class Bakery < ApplicationRecord
  include CloudflareImageable

  has_many :menu_items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :notes, dependent: :destroy

  has_cloudflare_images :images, column: :cloudflare_image_ids

  validates :name, presence: true
  validates :category, presence: true
  validates :road_address, presence: { message: "주소 검색 버튼을 클릭하여 주소를 입력해주세요" }
  validates :phone, presence: true

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
