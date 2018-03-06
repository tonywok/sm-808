require "spec_helper"

RSpec.describe Sm808::Sample do
  let(:sample) { described_class.new(:snare, pattern) }

  describe ".defaults" do
    it "creates all samples with inactive steps" do
      samples = described_class.defaults
      expect(samples.length).to eq(3)
      expect(samples[described_class::Kinds::KICK].step(0)).not_to be_active
      expect(samples[described_class::Kinds::SNARE].step(0)).not_to be_active
      expect(samples[described_class::Kinds::HIHAT].step(0)).not_to be_active
    end
  end

  describe "#duration" do
    let(:pattern) { "XXX" }

    it { expect(sample.duration).to eq(3) }
  end

  describe "#step" do
    let(:pattern) { "X0X0" }

    it { expect(sample.step(0)).to be_active }
    it { expect(sample.step(1)).not_to be_active }
    it { expect(sample.step(2)).to be_active }
    it { expect(sample.step(3)).not_to be_active }
    it { expect(sample.step(4)).to be_active }
    it { expect(sample.step(5)).not_to be_active }
    it { expect(sample.step(6)).to be_active }
    it { expect(sample.step(7)).not_to be_active }
    it { expect(sample.step(8)).to be_active }
  end
end
