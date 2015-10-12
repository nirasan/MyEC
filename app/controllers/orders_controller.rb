class OrdersController < ApplicationController
  before_action :authenticate_no_user_or_guest!
  before_action :set_order, only: [:show, :confirm, :confirmed, :result]

  def index
    @orders = current_user.orders.where(confirmed_flag: true).page(params[:page])
  end

  def show
  end

  def new
    @order = Order.new_by_user(current_user, session[:last_postal_data])
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.set_prices

    respond_to do |format|
      if @order.save
        session[:last_postal_data] = {
          name: @order.name,
          zip_code: @order.zip_code,
          address: @order.address,
          phone_number: @order.phone_number,
        }
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
        format.html { redirect_to result_order_path(@order), notice: '購入が完了しました' }
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
