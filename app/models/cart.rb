class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  validates :user_id, presence: true
end
