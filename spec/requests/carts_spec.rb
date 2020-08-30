require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let(:user_id) { 1 }

  describe 'POST /users/:user_id/carts' do
    it 'creates a new cart for the specified user' do
      expect do
        post user_carts_path(user_id, cart: { user_id: 1 })
      end.to change { Cart.count }.by(1)

      expect(response).to have_http_status(201)

      expect(resp_body['data']['type']).to eq 'cart'
      expect(resp_body['data']['attributes']['user_id']).to eq 1
      expect(resp_body['data']['relationships']['line_items']['data'].size).to eq 0
    end
  end

  context 'when user has cart assigned' do
    let!(:cart) { create :cart, line_items_count: 2, user_id: user_id }

    describe 'GET /users/:user_id/carts' do
      it 'returns all carts assigned to user' do
        get user_carts_path(user_id)

        expect(response).to have_http_status(200)

        expect(resp_body['data'].size).to eq 1
        expect(resp_body['data'][0]['type']).to eq 'cart'
      end
    end

    describe 'GET /users/:user_id/carts/:id' do
      it 'returns content of the cart' do
        get user_cart_path(user_id, cart.id)

        expect(response).to have_http_status(200)

        expect(resp_body['data']['type']).to eq 'cart'
        expect(resp_body['data']['relationships']['line_items']['data'].size).to eq 2
        expect(resp_body['included'].size).to eq 2
        expect(resp_body['included'][0]['type']).to eq 'line_item'
        expect(resp_body['included'][1]['type']).to eq 'line_item'
      end
    end

    describe 'DELETE /users/:user_id/carts/:id' do
      it 'removes the cart from the user' do
        expect do
          delete user_cart_path(user_id, cart.id)
        end.to change { Cart.count }.by(-1)

        expect(response).to have_http_status(204)

        expect(body).to be_empty
      end
    end
  end
end
