require 'spec_helper'

describe CartItem do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:cart_id) }
    it { should allow_mass_assignment_of(:item_id) }
    it { should allow_mass_assignment_of(:quantity) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:cart) }
    it { should validate_presence_of(:item) }
    it { should validate_presence_of(:quantity) }
  end

  context "validates quantity" do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:quantity).only_integer }
  end

  context "has associations" do
    it { should belong_to(:cart) }
    it { should belong_to(:item) }
  end

  let(:cart_item) { CartItem.new(item_id: 1, cart_id: 1, quantity: 3) }
  let(:item) { double("item", price: 35) }

  it "calculates subtotal for each item" do
    cart_item.stub(:item).and_return(item)
    expect(cart_item.subtotal).to eq(105)
  end

end
