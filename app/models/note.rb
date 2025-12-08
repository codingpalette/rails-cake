class Note < ApplicationRecord
  include CloudflareImageable

  belongs_to :user
  belongs_to :bakery

  has_cloudflare_images :images, column: :cloudflare_image_ids

  validates :content, presence: true
  validates :visit_date, presence: true

  scope :recent, -> { order(visit_date: :desc, created_at: :desc) }
  scope :public_notes, -> { where(is_public: true) }
  scope :private_notes, -> { where(is_public: false) }

  def toggle_public!
    update!(is_public: !is_public)
  end
end
