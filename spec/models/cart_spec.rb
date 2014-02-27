require 'spec_helper'

describe Cart do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:user_id) }
  end

  context "has associations" do
    it { should belong_to(:user) }
    it { should have_many(:cart_items) }
  end

  context "calculating the total cost" do
    let(:cart_item1) { double("cart_item", subtotal: 150) }
    let(:cart_item2) { double("cart_item", subtotal: 230) }
    let(:cart_item3) { double("cart_item", subtotal: 360) }
    let(:cart_items) { [cart_item1, cart_item2, cart_item3] }
    let(:user) { double("user") }
    let(:cart) { Cart.new(user_id: 1) }

    it "correctly calculates total cost of all items" do
      cart.stub(:cart_items).and_return(cart_items)
      cart_items.stub(:includes).and_return(cart_items)
      cart.stub(:user).and_return(user)
      cart.save!
      expect(cart.total).to eq(740)
    end
  end

end
