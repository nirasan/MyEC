class CartsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_cart, only: [:update, :destroy]

  def index
    @carts = current_user.carts.page(params[:page])
  end

  def create
    @cart = current_user.carts.build(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to carts_path, notice: "#{@cart.item.name}を#{@cart.amount}個カートに入れました" }
      else
        format.html { redirect_to item_path(@cart.item), alert: "カートに入れられませんでした" }
      end
    end
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to carts_path, notice: "#{@cart.item.name}の数量を変更しました" }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { redirect_to carts_path, alert: "#{@cart.item.name}の数量変更に失敗しました" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'カートから商品を削除しました' }
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
