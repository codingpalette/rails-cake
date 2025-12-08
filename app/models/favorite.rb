class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :bakery
  
  # 중복 방지 validation
  validates :user_id, uniqueness: { scope: :bakery_id }
end
