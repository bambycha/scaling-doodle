class LineItemsController < ApplicationController
  before_action :set_line_item, only: %i[update destroy]

  # POST /users/:user_id/carts/:cart_id/line_items
  def create
    @line_item = LineItem.new(line_item_params)

    if @line_item.save
      render json: LineItemSerializer.new(@line_item).serializable_hash, status: :created
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:user_id/carts/:cart_id/line_items/:id
  def update
    if @line_item.update(line_item_params)
      render json: LineItemSerializer.new(@line_item).serializable_hash
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/carts/:cart_id/line_items/:id
  def destroy
    @line_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def line_item_params
    params.require(:line_item).permit(:product_id, :cart_id, :quantity, :title, :price)
  end
end
