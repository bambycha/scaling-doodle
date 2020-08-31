class LineItem < ApplicationRecord
  belongs_to :cart

  validates :product_id, :title, :price, presence: true
end
