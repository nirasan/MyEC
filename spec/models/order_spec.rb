require 'rails_helper'
require 'pp'

RSpec.describe Order, type: :model do
  let!(:user1) { create(:user) }
  let!(:item1) { create(:item, price: 9800) }
  let!(:item2) { create(:item, price: 1200) }
  let!(:cart1) { create(:cart, user:user1, item:item1, amount: 1) }
  let!(:cart2) { create(:cart, user:user1, item:item2, amount: 10) }
  let!(:order1) { create(:order, user:user1) }
  describe 'new_by_user' do
    context '各種priceが計算されている' do
      before do
        @order2 = Order.new_by_user(user1)
      end
      it { expect(@order2.price).to eq 21800 }
      it { expect(@order2.cash_on_delivery_price).to eq 400 }
      it { expect(@order2.postage_price).to eq 1800 }
      it { expect(@order2.tax_price).to eq 1920 }
      it { expect(@order2.total_price).to eq 25920 }
    end
  end
  describe 'create_order_items' do
    context 'order_items が作成されている' do
      it { expect(order1.order_items.size).to eq 2 }
    end
  end
  describe 'confirmed' do
    context '購入確定するとカートが空になる' do
      before do
        order1.update(confirmed_flag: true)
      end
      it { expect(User.find(user1.id).carts.size).to eq 0 }
    end
  end
end
