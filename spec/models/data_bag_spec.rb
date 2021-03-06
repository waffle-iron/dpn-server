# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.


require 'rails_helper'

describe DataBag do
  it "has a valid factory" do
    expect(Fabricate(:data_bag)).to be_valid
  end

  describe "interpretive_bags" do
    it "updates updated_at when added" do
      bag = Fabricate(:data_bag, updated_at: 2.hours.ago)
      bag.interpretive_bags << Fabricate(:interpretive_bag)
      bag.save
      expect(bag.updated_at).to be > 2.hours.ago
    end
  end

  describe "rights_bags" do
    it "updates updated_at when added" do
      bag = Fabricate(:data_bag, updated_at: 2.hours.ago)
      bag.rights_bags << Fabricate(:rights_bag)
      bag.save
      expect(bag.updated_at).to be > 2.hours.ago
    end
  end
end