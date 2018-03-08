require "spec_helper"

RSpec.describe Sm808::DrumMachine do
  let(:interface) { Sm808::Interfaces::Test }
  let(:drum_machine) { described_class.new(interface: interface) }

  describe "#bpm" do
    it "defaults to 60" do
      expect(drum_machine.bpm).to eq(60)
    end

    it "can be changed" do
      drum_machine = described_class.new(interface: interface, bpm: 128)
      expect(drum_machine.bpm).to eq(128)
    end
  end

  describe "#playback" do
    context "with no patterns" do
      it "plays all noop notes" do
        expect(drum_machine.playback).to eq(<<~TXT)
                +---------------+
          kick  |0|0|0|0|0|0|0|0|
          snare |0|0|0|0|0|0|0|0|
          hihat |0|0|0|0|0|0|0|0|
                +---------------+
        TXT
      end
    end

    context "with patterns that have the same pattern length" do
      before do
        drum_machine.update_pattern(:kick,  "X000X000")
        drum_machine.update_pattern(:snare, "0XXX0XXX")
      end

      it "sequences both" do
        expect(drum_machine.playback).to eq(<<~TXT)
                +---------------+
          kick  |X|0|0|0|X|0|0|0|
          snare |0|X|X|X|0|X|X|X|
          hihat |0|0|0|0|0|0|0|0|
                +---------------+
        TXT
      end
    end

    context "with patterns of varying pattern length" do
      before do
        drum_machine.update_pattern(:kick, "X000X000")
        drum_machine.update_pattern(:snare, "000X00000000X000")
        drum_machine.update_pattern(:hihat, "0X")
      end

      it "sequences both, restarting the shorter sample" do
        expect(drum_machine.playback).to eq(<<~TXT)
                +-------------------------------+
          kick  |X|0|0|0|X|0|0|0|X|0|0|0|X|0|0|0|
          snare |0|0|0|X|0|0|0|0|0|0|0|0|X|0|0|0|
          hihat |0|X|0|X|0|X|0|X|0|X|0|X|0|X|0|X|
                +-------------------------------+
        TXT
      end
    end
  end
end
