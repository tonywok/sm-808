require "spec_helper"

RSpec.describe Sm808::Song do
  let(:song) { described_class.new }

  describe "#title" do
    it "defaults to untitled" do
      expect(song.title).to eq("Untitled")
    end
  end

  describe "#bpm" do
    it "defaults to 60" do
      expect(song.bpm).to eq(60)
    end

    it "can be overridden" do
      song = described_class.new(bpm: 128)
      expect(song.bpm).to eq(128)
    end
  end

  describe "#step_duration" do
    context "default BPM" do
      it "calculates based on BPM" do
        expect(song.step_duration).to eq(0.5)
      end
    end

    context "custom BPM" do
      it "calculates based on BPM" do
        song = described_class.new(bpm: 120)
        expect(song.step_duration).to eq(0.25)
      end
    end

    context "upon adding a sample with more steps" do
      it "recalculates" do
        song.add_pattern(:kick, "X000X000X000X000")
        expect(song.step_duration).to eq(0.25)
      end
    end
  end

  describe "#patterns" do
    it "has all patterns" do
      expect(song.patterns.keys).to eq(Pattern::Kinds::ALL)
    end
  end

  describe "#add_pattern" do
    it "replaces the default noop pattern" do
      expect(song.sample[:kick]).not_to be_active
      song.rewind
      song.add_pattern(:kick, "X000X000")
      expect(song.sample[:kick]).to be_active
    end
  end

  describe "#sample" do
    context "bunch of custom patterns" do
      before do
        song.add_pattern(:kick,  "X000X000")
        song.add_pattern(:snare, "0000X000")
        song.add_pattern(:hihat, "00X000X0")
      end

      it "extracts steps from each sample" do
        steps = song.sample
        expect(steps[:kick]).to be_active
        expect(steps[:snare]).not_to be_active
        expect(steps[:hihat]).not_to be_active
      end

      it "gracefully handles higher step counts" do
        10.times { song.sample }
        steps = song.sample
        expect(steps[:kick]).not_to be_active
        expect(steps[:snare]).not_to be_active
        expect(steps[:hihat]).to be_active
      end
    end

    context "no user defined patterns" do
      it "only has inactive notes" do
        steps = song.sample
        expect(steps[:kick]).not_to be_active
        expect(steps[:snare]).not_to be_active
        expect(steps[:hihat]).not_to be_active
      end
    end
  end
end
