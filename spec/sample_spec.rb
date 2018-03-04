require "spec_helper"

RSpec.describe Sm808::Sample do
  let(:sample) { described_class.new(:snare, pattern) }

  describe "#duration" do
    let(:pattern) { "XXX" }

    it { expect(sample.duration).to eq(3) }
  end

  describe "#note" do
    let(:pattern) { "X0X0" }

    it { expect(sample.note(0)).to be_active }
    it { expect(sample.note(1)).not_to be_active }
    it { expect(sample.note(2)).to be_active }
    it { expect(sample.note(3)).not_to be_active }
    it { expect(sample.note(4)).to be_active }
    it { expect(sample.note(5)).not_to be_active }
    it { expect(sample.note(6)).to be_active }
    it { expect(sample.note(7)).not_to be_active }
    it { expect(sample.note(8)).to be_active }
  end
end
