class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_order, only: [:show, :confirm, :confirmed, :result]

  def index
    @orders = current_user.orders.where(confirmed_flag: true)
  end

  def show
  end

  def new
    @order = Order.new_by_user(current_user)
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.set_prices

    respond_to do |format|
      if @order.save
        format.html { redirect_to confirm_order_path(@order) }
      else
        format.html { render :new }
      end
    end
  end

  def confirm
  end

  def confirmed
    respond_to do |format|
      if @order.update(confirmed_flag: true)
        format.html { redirect_to result_order_path(@order) }
      else
        format.html { render :confirm }
      end
    end
  end

  def result
  end

  private
    def set_order
      @order = current_user.orders.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :address, :zip_code, :phone_number, :delivery_date, :delivery_timezone)
    end
end
