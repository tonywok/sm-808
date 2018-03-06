require "spec_helper"

RSpec.describe Sm808::StepCounter do
  let(:counter) { described_class.new }

  describe "#duration" do
    it "defaults to 8" do
      expect(counter.duration).to eq(8)
    end
  end

  describe "#next_step" do
    it "cycles upon reaching the last step" do
      expect(counter.next_step).to eq(0)
      expect(counter.next_step).to eq(1)
      expect(counter.next_step).to eq(2)
      expect(counter.next_step).to eq(3)
      expect(counter.next_step).to eq(4)
      expect(counter.next_step).to eq(5)
      expect(counter.next_step).to eq(6)
      expect(counter.next_step).to eq(7)
      expect(counter.next_step).to eq(0)
    end
  end

  describe "#complete?" do
    it { expect(counter).not_to be_complete }

    context "upon stepping till completion" do
      before do
        counter.duration.times { counter.next_step }
      end

      it { expect(counter).to be_complete }
    end
  end

  describe "#resequence!" do
    context "before sequencing" do
      before { counter.resequence!(step_duration) }

      context "adding a same size pattern" do
        let(:step_duration) { counter.duration }

        it { expect(counter.duration).to eq(8) }
      end

      context "adding a smaller pattern" do
        let(:step_duration) { counter.duration - 4 }

        it { expect(counter.duration).to eq(8) }
      end

      context "adding a bigger pattern" do
        let(:step_duration) { counter.duration + 8 }

        it { expect(counter.duration).to eq(16) }
      end
    end

    context "during sequencing" do
      context "when complete" do
        before { counter.duration.times { counter.next_step } }

        it "continues until complete with new duration" do
          prior_duration = counter.duration
          counter.resequence!(16)
          expect(counter.next_step).to eq(prior_duration + 1)
          expect(counter.duration).to eq(16)
        end
      end

      context "when not complete" do
        before do
          3.times { counter.next_step }
        end

        it "resequences, fast forwarding to where it left off" do
          counter.resequence!(16)
          expect(counter.next_step).to eq(3)
          expect(counter.duration).to eq(16)
        end
      end
    end
  end
end
