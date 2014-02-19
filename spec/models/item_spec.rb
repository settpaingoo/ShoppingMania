require 'spec_helper'

describe Item do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:price) }
    it { should allow_mass_assignment_of(:stock) }
    it { should allow_mass_assignment_of(:brand_id) }
    it { should allow_mass_assignment_of(:category_id) }
    it { should allow_mass_assignment_of(:description) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:category) }
  end

  context "validates price" do
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  context "validates stock" do
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:stock).only_integer }
  end

  context "has associations" do
    it { should belong_to(:brand) }
    it { should belong_to(:category) }
  end

  let(:brand) { double("brand") }
  let(:category) { double("category") }
  let(:item) { Item.new(name: "A", price: 10, stock: 15, brand_id: 1, category_id: 1) }

  context "adding more stock" do
    before do
      item.stub(:brand).and_return(brand)
      item.stub(:category).and_return(category)
    end

    it "should increase stock for valid numbers" do
      expect(item.add_stock(3)).to be_true
      expect(item.stock).to eq(18)
    end

    it "should not increase stock for invalid numbers" do
      expect(item.add_stock(0)).to be_false
      expect(item.add_stock(-4)).to be_false
      expect(item.stock).to eq(15)
    end
  end

  context "removing from stock" do
    before do
      item.stub(:brand).and_return(brand)
      item.stub(:category).and_return(category)
    end

    it "should decrease stock for valid numbers" do
      expect(item.remove_stock(4)).to be_true
      expect(item.stock).to eq(11)
    end

    it "should not decrease stock for invalid numbers" do
      expect(item.remove_stock(0)).to be_false
      expect(item.remove_stock(-3)).to be_false
      expect(item.stock).to eq(15)
    end

    it "should not allow to remove more than current stock" do
      expect(item.remove_stock(16)).to be_false
      expect(item.stock).to eq(15)
    end
  end
  #need to write specs for class methods
end
