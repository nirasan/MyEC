class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy, :confirm, :confirmed, :result]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new_by_user(current_user)
  end

  def edit
  end

  def create
    @order = current_user.orders.build(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to confirm_order_path(@order), notice: 'Order was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm
  end

  def confirmed
    respond_to do |format|
      if @order.update(confirmed_flag: true)
        format.html { redirect_to result_order_path(@order), notice: 'Order was successfully updated.' }
      else
        format.html { render :confirm }
      end
    end
  end

  def result
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :address, :zip_code, :phone_number, :price)
    end
end
