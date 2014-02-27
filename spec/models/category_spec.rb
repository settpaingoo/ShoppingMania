require 'spec_helper'

describe Category do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:parent_category_id) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:name) }
  end

  context "has associations" do
    it { should belong_to(:parent_category) }
    it { should have_many(:sub_categories) }
  end
end
