class ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @items = Item.visible.order_by_priority.all
  end

  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end
end
