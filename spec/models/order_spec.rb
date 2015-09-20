require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user1) { create(:user) }
  let!(:item1) { create(:item) }
  let!(:item2) { create(:item) }
  let!(:cart1) { create(:cart, user:user1, item:item1) }
  let!(:cart2) { create(:cart, user:user1, item:item2) }
  let!(:order1) { create(:order, user:user1) }
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
