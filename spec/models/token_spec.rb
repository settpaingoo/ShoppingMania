require 'spec_helper'

describe Token do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:user_id) }
    it { should_not allow_mass_assignment_of(:token_string) }
  end

  context "validates presence of user" do
    it { should validate_presence_of(:user) }
  end

  context "has associations" do
    it { should belong_to(:user) }
  end
end
