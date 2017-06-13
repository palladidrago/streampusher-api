require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin owner" }
  describe "username" do
    it "is set from email if no username is present" do
      user = User.create email: "mcfiredrill@gmail.com", time_zone: "Tokyo", role: "admin owner"
      expect(user.username).to eq "mcfiredrill"
    end
  end

  describe "roles" do
    it "adds a new role" do
      user.add_role "dj"
      expect(user.roles.include?("admin")).to eq true
      expect(user.roles.include?("owner")).to eq true
      expect(user.roles.include?("dj")).to eq true
    end
  end

  describe "soft delete" do
    it "soft deletes an account" do
      user.soft_delete
      expect(user.deleted_at).to_not eq nil
    end
  end
end
