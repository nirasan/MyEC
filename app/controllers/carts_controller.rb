class CartsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_cart, only: [:update, :destroy]

  def index
    @carts = current_user.carts
  end

  def create
    @cart = current_user.carts.build(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to carts_path, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to carts_path, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cart
      @cart = current_user.carts.find(params[:id])
    end

    def cart_params
      params.require(:cart).permit(:item_id, :amount)
    end
end
