require "rails_helper"

RSpec.describe SurvivorController, type: :controller do
  describe "POST #create" do
    context "when pass valid params without inventory" do
      let(:valid_params_without_inventory) do
        {
          "survivor": {
            "name": "ok",
            "age": 24,
            "gender": "male",
            "latitude": 125.6,
            "longitude": 125.6
          }
        }
      end

      it "create a new survivor" do
        expect { post :create, params: valid_params_without_inventory }.to change(Survivor, :count).from(0).to(1)
      end

      it "return status 200" do
        post :create, params: valid_params_without_inventory
        expect(response.code).to eq("200")
      end
    end

    context "when pass valid params with inventory" do
      let(:valid_params_with_inventory) do
        {
          "survivor": {
            "name": "ok",
            "age": 24,
            "gender": "male",
            "latitude": 125.6,
            "longitude": 125.6,
            "inventory_attributes": [{
              "type": "Resource::Water"
              }]
            }
          }
      end

      it "create a new survivor with inventory of resources" do
        expect { post :create, params: valid_params_with_inventory }.to change(Survivor, :count).from(0).to(1)
          .and change(Resource::Water, :count).from(0).to(1)
      end

      it "return status 200" do
        post :create, params: valid_params_with_inventory
        expect(response.code).to eq("200")
      end
    end

    context "when pass invalid params" do
      let(:invalid_params) do
        {
          "survivor": {
            "name": "",
            "age": 24,
            "gender": "male",
            "latitude": 125.6,
            "longitude": 125.6
          }
        }
      end
      it "don't create a new survivor" do
        expect { post :create, params: invalid_params }.not_to change(Survivor, :count)
      end
      it "return 400 status with failure massage" do
        post :create, params: invalid_params
        expect(response.code).to eq("400")
        expect(response.body).to include("Failed to create a new survivor")
      end
    end
  end
end
