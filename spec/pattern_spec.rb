require "spec_helper"

RSpec.describe Sm808::Pattern do
  let(:pattern) { described_class.new(:snare, step_indicators) }

  describe ".defaults" do
    it "creates all patterns with inactive steps" do
      patterns = described_class.defaults
      expect(patterns.length).to eq(3)
      expect(patterns[Samples::KICK].step(0)).not_to be_active
      expect(patterns[Samples::SNARE].step(0)).not_to be_active
      expect(patterns[Samples::HIHAT].step(0)).not_to be_active
    end
  end

  describe "#duration" do
    let(:step_indicators) { "XXX" }

    it { expect(pattern.duration).to eq(3) }
  end

  describe "#step" do
    let(:step_indicators) { "X0X0" }

    it { expect(pattern.step(0)).to be_active }
    it { expect(pattern.step(1)).not_to be_active }
    it { expect(pattern.step(2)).to be_active }
    it { expect(pattern.step(3)).not_to be_active }
    it { expect(pattern.step(4)).to be_active }
    it { expect(pattern.step(5)).not_to be_active }
    it { expect(pattern.step(6)).to be_active }
    it { expect(pattern.step(7)).not_to be_active }
    it { expect(pattern.step(8)).to be_active }
  end

  describe "#update_step" do
    context "updating step inside the bounds of the pattern" do
      let(:step_indicators) { "000" }

      it "updates the pattern in place" do
        pattern.update_step(1, true)
        expect(pattern.step(1)).to be_active
        pattern.update_step(1, false)
        expect(pattern.step(1)).not_to be_active
      end
    end

    context "updating step inside the bounds of the patthern" do
      let(:step_indicators) { "0X0" }

      it "increases the size of the pattern filling in the delta with inactive steps" do
        pattern.update_step(4, true)
        expect(pattern.step(4)).to be_active
        expect(pattern.step(3)).not_to be_active
        expect(pattern.step(2)).not_to be_active
        expect(pattern.step(1)).to be_active
        expect(pattern.step(0)).not_to be_active
        pattern.update_step(5, false)
        expect(pattern.step(5)).not_to be_active
      end
    end
  end
end
