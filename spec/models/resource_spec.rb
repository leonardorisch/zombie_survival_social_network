require 'rails_helper'

RSpec.shared_examples "create Resource by type return right points" do |type, points|
  it "uses the given parameter" do
    resource = build(type.to_sym)
    expect(resource.points).to eq(points)
  end
end

RSpec.describe Resource, type: :model do

  describe "#save" do
    context "when pass valid params" do
      let(:valid_resource) { build(:water_resource) }

      it "then create a new Resource object" do
        expect { valid_resource.save }.to change(Resource, :count).from(0).to(1)
      end

      include_examples "create Resource by type return right points", 'water_resource', 4
      include_examples "create Resource by type return right points", 'food_resource', 3
      include_examples "create Resource by type return right points", 'medication_resource', 2
      include_examples "create Resource by type return right points", 'ammunition_resource', 1
    end
  end
end
