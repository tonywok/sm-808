require "spec_helper"

RSpec.describe Sm808::DrumMachine do
  let(:interface) { Sm808::Interfaces::Text.new }
  let(:drum_machine) { described_class.new(interface: interface) }

  describe "#playback" do
    context "with no samples" do
      it "plays all noop notes" do
        expect(drum_machine.playback).to eq(<<~TXT)
          +---------------+
          |0|0|0|0|0|0|0|0|
          |0|0|0|0|0|0|0|0|
          |0|0|0|0|0|0|0|0|
          +---------------+
        TXT
      end
    end

    context "with samples that have the same pattern length" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "0XXX0XXX") }

      before do
        drum_machine.add_sample(kick)
        drum_machine.add_sample(snare)
      end

      it "sequences both" do
        expect(drum_machine.playback).to eq(<<~TXT)
          +---------------+
          |X|0|0|0|X|0|0|0|
          |0|X|X|X|0|X|X|X|
          |0|0|0|0|0|0|0|0|
          +---------------+
        TXT
      end
    end

    context "with samples of varying pattern length" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "000X00000000X000") }
      let(:hihat) { Sample.new(:hihat, "0X") }

      before do
        drum_machine.add_sample(kick)
        drum_machine.add_sample(snare)
        drum_machine.add_sample(hihat)
      end

      it "sequences both, restarting the shorter sample" do
        expect(drum_machine.playback).to eq(<<~TXT)
          +-------------------------------+
          |X|0|0|0|X|0|0|0|X|0|0|0|X|0|0|0|
          |0|0|0|X|0|0|0|0|0|0|0|0|X|0|0|0|
          |0|X|0|X|0|X|0|X|0|X|0|X|0|X|0|X|
          +-------------------------------+
        TXT
      end
    end
  end
end
