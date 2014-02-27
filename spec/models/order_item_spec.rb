require 'spec_helper'

describe OrderItem do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:order_id) }
    it { should allow_mass_assignment_of(:item_id) }
    it { should allow_mass_assignment_of(:price) }
    it { should allow_mass_assignment_of(:quantity) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:order) }
    it { should validate_presence_of(:item) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:quantity) }
  end

  context "validates quantity" do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:quantity).only_integer }
  end

  context "validates price" do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  context "has associations" do
    it { should belong_to(:order) }
    it { should belong_to(:item) }
  end
end
