require 'rails_helper'

RSpec.describe InventoryController, type: :controller do
  describe "POST #trade" do
    let(:first_survivor) { create(:survivor_with_water_resource) }
    let(:second_survivor) { create(:survivor_with_water_resource) }
    let(:resource_param) do
      ActionController::Parameters.new({
        "type": "Resource::Water"
      })
    end
    let(:trade_service) { double(ProcessTradeService) }
    let(:trader_params) do
      {
        "first_survivor_trader": {
          "survivor_id": first_survivor.id,
      		"inventory_attributes": {
      			"type": "Resource::Water"
      		}
        },
        "second_survivor_trader": {
      		"survivor_id": second_survivor.id,
      		"inventory_attributes": {
      			"type": "Resource::Water"
      		}
        }
      }
    end

    let(:expected_first_trader_params) do
      ActionController::Parameters.new(
        "survivor_id": first_survivor.id.to_s,
    		"inventory_attributes": resource_param
      )
    end
    let(:expected_second_trader_params) do
      ActionController::Parameters.new(
        "survivor_id": second_survivor.id.to_s,
    		"inventory_attributes": resource_param
      )
    end

    before do
      ActionController::Parameters.permit_all_parameters = true
      allow(ProcessTradeService).to receive(:new).and_return(trade_service)
      allow(trade_service).to receive(:call).and_return('true')
    end

    context "process trade" do
      it "call service to process" do
        expect(ProcessTradeService).to receive(:new).with(
          expected_first_trader_params, expected_second_trader_params
        )
        post :trade, params: trader_params
      end
    end
  end
end
