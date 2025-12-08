class User < ApplicationRecord
  include CloudflareImageable

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_bakeries, through: :favorites, source: :bakery
  has_many :notes, dependent: :destroy

  has_cloudflare_image :profile_image, column: :cloudflare_profile_image_id

  normalizes :email_address, with: ->(e) { e.strip.downcase }

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
end
