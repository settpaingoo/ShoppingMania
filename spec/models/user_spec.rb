require 'spec_helper'

describe User do
  context "allows mass-assignment of attributes" do
    it { should allow_mass_assignment_of(:first_name) }
    it { should allow_mass_assignment_of(:last_name) }
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should_not allow_mass_assignment_of(:password_digest) }
  end

  context "validates presence of mandatory attributes" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end

  context "validates minimum password length" do
    it { should ensure_length_of(:password).is_at_least(6) }
  end

  context "has secure password" do
    it { should have_secure_password }
  end

  context "only allows unique email addresses" do
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context "checks correct email format" do
    it { should allow_value("email@email.com", "e.ma_il@email.com").for(:email) }
    it { should_not allow_value("www.email.com", "email@ema@il.com").for(:email) }
  end

  context "has associations" do
    it { should have_many(:tokens) }
    it { should have_one(:cart) }
    it { should have_many(:orders) }
  end

  context "finds correctly by given credentials" do
    let(:user) { User.create!(first_name: "A", last_name: "B", email:"a@b.com", password:"abcdef") }

    it "finds the correct user" do
      user
      expect(User.find_by_credentials("a@b.com", "abcdef")).to eq(user)
    end

    it "doesn't find the user when given incorrect credentials" do
      expect(User.find_by_credentials("b@a.com", "abcdef")).to eq(nil)
      expect(User.find_by_credentials("a@b.com", "")).to eq(nil)
      expect(User.find_by_credentials("a@b.com", "abcdefg")).to eq(nil)
    end
  end
end
