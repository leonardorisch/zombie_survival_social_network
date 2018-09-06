require 'rails_helper'

RSpec.describe ProcessInfectationService do
  describe "#call" do
    let(:redis) { Redis.new }
    let(:survivor_infected) { create(:survivor) }
    let(:survivor_reporter1) { create(:survivor) }
    let(:survivor_reporter2) { 'randomid1' }
    let(:survivor_reporter3) { 'randomid2' }

    before do
      allow(Redis).to receive(:new).and_return(redis)
    end

    context "when infected was already reported" do
      it "return status with message" do
        allow(redis).to receive(:lrange).and_return([survivor_reporter1.id.to_s])
        expect(described_class.new(survivor_infected, survivor_reporter1).call)
        .to match_array(["Already reported by current reporter", 422])
      end
    end

    context "when report is counted but not for mark as infected" do
      it "return status with message" do
        allow(redis).to receive(:lrange).and_return([])
        allow(redis).to receive(:lpush).and_return(1)
        expect(described_class.new(survivor_infected, survivor_reporter1).call)
        .to match_array(["Report counted", 200])
      end
    end

    context "when mark as infected" do
      it "return status with message" do
        allow(redis).to receive(:lrange).and_return([survivor_reporter2, survivor_reporter3])
        allow(redis).to receive(:lpush).and_return(3)
        expect(described_class.new(survivor_infected, survivor_reporter1).call)
        .to match_array(["Survivor marked as infected", 200])
      end
    end
  end
end
