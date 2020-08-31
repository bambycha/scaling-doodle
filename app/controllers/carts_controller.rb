class CartsController < ApplicationController
  before_action :set_cart, only: %i[show destroy]

  # GET /users/1/carts
  def index
    @carts = Cart.includes(:line_items).where(user_id: params[:user_id])

    render json: CartSerializer.new(@carts).serializable_hash
  end

  # GET /users/1/carts/1
  def show
    render json: CartSerializer.new(@cart, include: [:line_items]).serializable_hash
  end

  # POST /users/1/carts
  def create
    @cart = Cart.new(cart_params)

    if @cart.save
      render json: CartSerializer.new(@cart).serializable_hash, status: :created
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1/carts/1
  def destroy
    @cart.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.includes(:line_items).find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
