require "spec_helper"

RSpec.describe Sm808::StepSequence do
  let(:step_sequence) { described_class.new }

  describe "#duration" do
    it "defaults to 8" do
      expect(step_sequence.duration).to eq(8)
    end
  end

  describe "#next_step" do
    it "cycles upon reaching the last step" do
      expect(step_sequence.next_step).to eq(0)
      expect(step_sequence.next_step).to eq(1)
      expect(step_sequence.next_step).to eq(2)
      expect(step_sequence.next_step).to eq(3)
      expect(step_sequence.next_step).to eq(4)
      expect(step_sequence.next_step).to eq(5)
      expect(step_sequence.next_step).to eq(6)
      expect(step_sequence.next_step).to eq(7)
      expect(step_sequence.next_step).to eq(0)
    end
  end

  describe "#complete?" do
    it { expect(step_sequence).not_to be_complete }

    context "upon stepping till completion" do
      before do
        step_sequence.duration.times { step_sequence.next_step }
      end

      it { expect(step_sequence).to be_complete }
    end
  end

  describe "#resequence!" do
    context "before sequencing" do
      before { step_sequence.resequence!(step_duration) }

      context "adding a same size pattern" do
        let(:step_duration) { step_sequence.duration }

        it { expect(step_sequence.duration).to eq(8) }
      end

      context "adding a smaller pattern" do
        let(:step_duration) { step_sequence.duration - 4 }

        it { expect(step_sequence.duration).to eq(8) }
      end

      context "adding a bigger pattern" do
        let(:step_duration) { step_sequence.duration + 8 }

        it { expect(step_sequence.duration).to eq(16) }
      end
    end

    context "during sequencing" do
      context "when complete" do
        before { step_sequence.duration.times { step_sequence.next_step } }

        it "continues until complete with new duration" do
          prior_duration = step_sequence.duration
          step_sequence.resequence!(16)
          expect(step_sequence.next_step).to eq(prior_duration + 1)
          expect(step_sequence.duration).to eq(16)
        end
      end

      context "when not complete" do
        before do
          3.times { step_sequence.next_step }
        end

        it "resequences, fast forwarding to where it left off" do
          step_sequence.resequence!(16)
          expect(step_sequence.next_step).to eq(3)
          expect(step_sequence.duration).to eq(16)
        end
      end
    end
  end
end
