require "rails_helper"

RSpec.describe AdminHelper do
  describe "current_section?" do
    it "returns the correct class name if the controller name matches" do
      expect(helper.current_section?("foo", {controller: "foo"})).to eq "is-active"
    end

    it "is empty if the controller name does not match" do
      expect(helper.current_section?("foo", {controller: "bar"})).to eq nil
      expect(helper.current_section?("foo", {controller: "foooo"})).to eq nil
    end
  end
end
