require 'rails_helper'

RSpec.describe InfectationController do
  describe "POST #report_contamination" do
    let(:infected) { create(:survivor) }
    let(:reporter) { create(:survivor) }
    let(:service) { double(ProcessInfectationService) }
    let(:redis) { Redis.new }
    let(:valid_params) do
      {
        "infected_id": infected.id,
        "reporter_id": reporter.id,
      }
    end

    before do
      allow(Redis).to receive(:new).and_return(redis)
      allow(ProcessInfectationService).to receive(:new).and_return(service)
    end

    context "when survivor is already infected" do
      before { infected.update(infected: true) }

      it 'return status 200 with a message' do
        post :report, params: valid_params
        expect(JSON.parse(response.body)['message']).to eq('Already infected')
        expect(response.code).to eq('200')
      end
    end

    context "when survivor is not infected yet" do
      it 'call process service' do
        allow(service).to receive(:call)
        expect(ProcessInfectationService).to receive(:new).with(
          infected, reporter
        )
        post :report, params: valid_params
      end
    end

    context "when survivor is not found" do
      let(:invalid_params) do
        {
          "infected_id": 'invalid_id',
          "reporter_id": reporter.id,
        }
      end
      it 'return not found status with message' do
        post :report, params: invalid_params
        expect(JSON.parse(response.body)['message']).to eq("Infected or reporter not found")
        expect(response.code).to eq("404")
      end
    end
  end
end
