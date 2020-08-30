class LineItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :product_id, :quantity, :title, :price, :created_at, :updated_at

  belongs_to :cart
end
