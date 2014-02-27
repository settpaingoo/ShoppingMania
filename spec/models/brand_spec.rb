require 'spec_helper'

describe Brand do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:name) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:name) }
  end

end
