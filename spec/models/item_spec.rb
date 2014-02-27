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

  3.times { |i| FactoryGirl.create(:brand, name: "Brand#{i+1}")}
  3.times { |i| FactoryGirl.create(:category, name: "Category#{i+1}")}

  context "filter items" do
    item1 = FactoryGirl.create(:item, price: 10)
    item2 = FactoryGirl.create(:item, price: 5, category_id: 2)
    item3 = FactoryGirl.create(:item, price: 7, brand_id: 2)
    items = Item.where("id > 0")

    it "should filter by price" do
      filtered_items1 = Item.filter_by_price(items, min: 6)
      filtered_items2 = Item.filter_by_price(items, max: 8)
      filtered_items3 = Item.filter_by_price(items, min: 6, max: 9)

      expect(filtered_items1).to eq([item1, item3])
      expect(filtered_items2).to eq([item2, item3])
      expect(filtered_items3).to eq([item3])
    end

    it "should filter by brand id" do
      filtered_items = Item.filter_by_brand(items, [1])

      expect(filtered_items).to match_array([item1, item2])
    end

    it "should filter by category id" do
      filtered_items = Item.filter_by_category(items, [2])

      expect(filtered_items).to eq([item2])
    end

  end
end
