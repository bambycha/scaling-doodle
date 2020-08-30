class CartSerializer
  include FastJsonapi::ObjectSerializer

  attributes :user_id, :created_at, :updated_at

  has_many :line_items
end
