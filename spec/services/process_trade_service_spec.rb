require 'rails_helper'

RSpec.describe ProcessTradeService do
  describe "#call" do
    let(:first_survivor) { create(:survivor) }
    let(:second_survivor) { create(:survivor) }

    let(:first_trader_params) do
      ActionController::Parameters.new(
    		"survivor_id": first_survivor.id,
    		"inventory_attributes": [{
    			"type": "Resource::Water"
    		}]
      )
    end

    let(:second_trader_params) do
      ActionController::Parameters.new(
    		"survivor_id": second_survivor.id,
    		"inventory_attributes": [{
    			"type": "Resource::Water"
    		}]
      )
    end

    context "when has survivors infected" do
      before { first_survivor.update(infected: true) }

      it "return unprocessable status with a message" do
        expect(described_class.new(first_trader_params, second_trader_params).call)
          .to match_array(["Survivors cannot be infected", 422])
      end
    end

    context "when resource points is not equal" do
      before do
        second_survivor.inventory << build(:water_resource)
        resource = first_survivor.inventory << build(:water_resource)
        resource.update(type: Resource::RESOURCE_TYPES[:FOOD])
      end

      it "return unprocessable status with a message" do
        expect(described_class.new(first_trader_params, second_trader_params).call)
          .to match_array(["Resource values must me equal", 422])
      end
    end

    context "when has valid params" do
      before do
        first_survivor.inventory << build_list(:water_resource, 3)
        second_survivor.inventory << build_list(:water_resource, 3)
      end

      let!(:expected_first_trader_resources) { second_survivor.inventory.pluck :id }
      let!(:expected_second_trader_resources) { first_survivor.inventory.pluck :id }

      it "return ok status with a message" do
        expect(described_class.new(first_trader_params, second_trader_params).call)
          .to match_array(["Trade done successfully", 200])
      end

      it "trade resource items between survivors" do
        described_class.new(first_trader_params, second_trader_params).call
        expect(first_survivor.inventory.pluck(:id)).to eq(expected_first_trader_resources)
        expect(second_survivor.inventory.pluck(:id)).to eq(expected_second_trader_resources)
      end
    end

    context "when has valid params but different types of resources" do
      let(:second_trader_params) do
        ActionController::Parameters.new(
      		"survivor_id": second_survivor.id,
      		"inventory_attributes": [
            {
      			  "type": "Resource::Food"
            },
            {
      			  "type": "Resource::Medication"
            }
          ]
        )
      end

      before do
        first_survivor.inventory << build_list(:water_resource, 2)
        second_survivor.inventory << build_list(:food_resource, 2)
        second_survivor.inventory << build(:medication_resource)
      end

      let!(:expected_first_trader_resources) { second_survivor.inventory.pluck :id }
      let!(:expected_second_trader_resources) { first_survivor.inventory.pluck :id }

      it "return ok status with a message" do
        expect(described_class.new(first_trader_params, second_trader_params).call)
          .to match_array(["Trade done successfully", 200])
      end

      it "trade resource items between survivors" do
        described_class.new(first_trader_params, second_trader_params).call
        expect(first_survivor.inventory.pluck(:id)).to eq(expected_first_trader_resources)
        expect(second_survivor.inventory.pluck(:id)).to eq(expected_second_trader_resources)
      end
    end

    context "when has any error processing trade" do
      let(:klass_instance) { described_class.new(first_trader_params, second_trader_params) }
      it "return error 500 with a message" do
        allow(klass_instance).to receive(:process_trade).and_raise(StandardError)
        expect(klass_instance.call).to match_array(["Error processing trade StandardError", 500])
      end
    end
  end
end
