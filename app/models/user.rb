class User < ApplicationRecord
  include CloudflareImageable

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_bakeries, through: :favorites, source: :bakery
  has_many :notes, dependent: :destroy

  has_cloudflare_image :profile_image, column: :cloudflare_profile_image_id

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_create :generate_nickname

  FORBIDDEN_NICKNAMES = %w[
    관리자 admin administrator 운영자 운영진 매니저 manager
    시스템 system 공식 official 케이크몰 cakemall staff 스태프
  ].freeze

  validates :nickname, uniqueness: true, allow_nil: true
  validate :nickname_not_forbidden

  # Admin methods
  def admin?
    admin
  end

  def make_admin!
    update!(admin: true)
  end

  def remove_admin!
    update!(admin: false)
  end

  private

  def nickname_not_forbidden
    return if nickname.blank?
    return if admin?

    normalized = nickname.downcase.gsub(/[\s\-_]/, "")
    if FORBIDDEN_NICKNAMES.any? { |word| normalized.include?(word.downcase) }
      errors.add(:nickname, "에 사용할 수 없는 단어가 포함되어 있습니다")
    end
  end

  def generate_nickname
    return if nickname.present?

    # 다음 번호를 찾아서 cake-N 형식으로 생성
    loop do
      next_number = (User.maximum(:id) || 0) + 1 + rand(1000)
      candidate = "cake-#{next_number}"

      unless User.exists?(nickname: candidate)
        self.nickname = candidate
        break
      end
    end
  end
end
