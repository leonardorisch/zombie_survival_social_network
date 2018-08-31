require 'rails_helper'

RSpec.describe Survivor do
  describe "#save" do
    context "when pass valid attributes" do
      let(:valid_survivor) { build(:survivor) }

      it "then create a new Survivor object" do
        expect{ valid_survivor.save }.to change(Survivor, :count).from(0).to(1)
      end
    end

    context "when pass invalid attributes" do
      let(:invalid_survivor) { build(:survivor, name: '') }

      it "then don't create a new Survivor object" do
        expect{ invalid_survivor.save }.not_to change(Survivor, :count)
      end
    end
  end
end
