FactoryBot.define do
  factory :line_item do
    cart
    sequence :product_id

    sequence(:title) { |n| "Product Title #{n}" }
    price { 42.0 }
  end
end
