require 'rails_helper'

RSpec.describe 'LineItems', type: :request do
  let(:user_id) { 1 }

  context 'when user has cart assigned' do
    let!(:cart) { create :cart, line_items_count: 2, user_id: user_id }
    let(:line_item) { cart.line_items.first }

    describe 'POST /users/:user_id/carts/:cart_id/line_items' do
      let(:new_item_params) do
        { product_id: 1, cart_id: cart.id, quantity: 24, title: 'new product', price: 42 }
      end

      it 'creates a new line item for the specified user cart' do
        expect do
          post user_cart_line_items_path(user_id, cart.id, line_item: new_item_params)
        end.to change { LineItem.count }.by(1)

        expect(response).to have_http_status(201)

        expect(resp_body['data']['type']).to eq 'line_item'
        expect(resp_body['data']['attributes']['product_id']).to eq 1
        expect(resp_body['data']['attributes']['quantity']).to eq 24
        expect(resp_body['data']['attributes']['title']).to eq 'new product'
        expect(resp_body['data']['attributes']['price']).to eq '42.0'
      end
    end

    describe 'PATCH /users/:user_id/carts/:cart_id/line_items/:id' do
      it 'updates existing line item for the specified user cart' do
        put user_cart_line_item_path(user_id, cart.id, line_item.id, line_item: { quantity: 42 })

        expect(response).to have_http_status(200)

        expect(resp_body['data']['type']).to eq 'line_item'
        expect(resp_body['data']['attributes']['quantity']).to eq 42
      end
    end

    describe 'DELETE /users/:user_id/carts/:id' do
      it 'removes the line item from the specified user cart' do
        expect do
          delete user_cart_line_item_path(user_id, cart.id, line_item.id)
        end.to change { LineItem.count }.by(-1)

        expect(response).to have_http_status(204)

        expect(body).to be_empty
      end
    end
  end
end
