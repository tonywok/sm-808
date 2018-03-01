require "spec_helper"

RSpec.describe Sm808::Sequencer do
  let(:sequencer) { described_class.new }

  describe "#step" do
    context "with no samples" do
      it "loops with no samples" do
        8.times { expect(sequencer.step).to eq("_") }
      end
    end

    context "with many samples" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "0000X000") }
      let(:hihat) { Sample.new(:hihat, "00X000X0") }

      before do
        sequencer.add(kick)
        sequencer.add(snare)
        sequencer.add(hihat)
      end

      it "sequences the samples" do
        expect(sequencer.step).to eq("kick")
        expect(sequencer.step).to eq("_")
        expect(sequencer.step).to eq("hihat")
        expect(sequencer.step).to eq("_")
        expect(sequencer.step).to eq("kick+snare")
        expect(sequencer.step).to eq("_")
        expect(sequencer.step).to eq("hihat")
        expect(sequencer.step).to eq("_")
      end
    end
  end
end
