require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "GET #report" do
    context "when has survivor and resources" do
      let(:expected_params) do
        {
          'percentage_infected'=> 33.3,
          'percentage_non_infected'=> 66.7,
          'average_resources_by_survivor'=> {
            'Resource::Water'=> 1.0,
            'Resource::Food'=> 2.0,
            'Resource::Medication'=> 3.0,
            'Resource::Ammunition'=> 0.0
          },
          'lost_points_by_infected'=> 48
        }
      end
      let(:infected_survivor) { create(:survivor, infected: true) }
      before do
        2.times { create(:survivor) }
        3.times { create(:water_resource, survivor: infected_survivor) }
        6.times { create(:food_resource, survivor: infected_survivor) }
        9.times { create(:medication_resource, survivor: infected_survivor) }
      end
      it "return object with valid data" do
        get :show
        expect(JSON.parse(response.body)).to eq(expected_params)
      end
    end

    context "when don't have survivors and resources" do
      let(:expected_empty_params) do
        {
          'percentage_infected'=> nil,
          'percentage_non_infected'=> nil,
          'average_resources_by_survivor'=> {
            'Resource::Water'=> nil,
            'Resource::Food'=> nil,
            'Resource::Medication'=> nil,
            'Resource::Ammunition'=> nil
          },
          'lost_points_by_infected'=> 0
        }
      end
      it "return object with valid data" do
        get :show
        expect(JSON.parse(response.body)).to eq(expected_empty_params)
      end
    end
  end
end
