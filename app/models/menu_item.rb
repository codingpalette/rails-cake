class MenuItem < ApplicationRecord
  include CloudflareImageable

  belongs_to :bakery

  has_cloudflare_image :image, column: :cloudflare_image_id

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
