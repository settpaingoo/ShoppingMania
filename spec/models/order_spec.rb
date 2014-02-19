require 'spec_helper'

describe Order do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:user_id) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:user) }
  end

  context "has associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
  end

  #need to add specs for add_items
end
