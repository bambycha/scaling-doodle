FactoryBot.define do
  factory :cart do
    sequence :user_id

    transient do
      line_items_count { 0 }
    end

    after(:create) do |cart, evaluator|
      create_list :line_item, evaluator.line_items_count, cart: cart
    end
  end
end
