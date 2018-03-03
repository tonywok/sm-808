require "spec_helper"

RSpec.describe Sm808::Sample do
  let(:sample) { described_class.new(:snare, pattern) }

  describe "active?" do
    subject { sample.active?(step) }

    context "with an active step" do
      let(:pattern) { "X0000000" }
      let(:step) { 0 }

      it { is_expected.to be_truthy }
    end

    context "with an inactive step" do
      let(:pattern) { "0XXXXXXX" }
      let(:step) { 0 }

      it { is_expected.to be_falsey }
    end

    context "when step is out of bounds" do
      let(:step) { 10 }

      context "after repeating onto an inactive step" do
        let(:pattern) { "XX0XXXXX" }

        it { is_expected.to be_falsey }
      end

      context "after repeating onto an active step" do
        let(:pattern) { "00X00000" }

        it { is_expected.to be_truthy }
      end
    end
  end
end
