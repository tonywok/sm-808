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
      let(:kick) { Sample.new(:kick, "X000X000X000X000") }

      it "recalculates" do
        song.add_sample(kick)
        expect(song.step_duration).to eq(0.25)
      end
    end
  end

  describe "#samples" do
    it "has all samples" do
      expect(song.samples.keys).to eq(Sample::Kinds::ALL)
    end
  end

  describe "#add_sample" do
    let(:kick) { Sample.new(:kick, "X000X000") }

    it "replaces the default inactive samples" do
      song.add_sample(kick)
      expect(song.samples[:kick]).to be(kick)
    end
  end

  describe "#sample" do
    let(:kick)  { Sample.new(:kick,  "X000X000") }
    let(:snare) { Sample.new(:snare, "0000X000") }
    let(:hihat) { Sample.new(:hihat, "00X000X0") }

    context "bunch of custom samples" do
      before do
        song.add_sample(kick)
        song.add_sample(snare)
        song.add_sample(hihat)
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

    context "no user defined samples" do
      it "only has inactive notes" do
        steps = song.sample
        expect(steps[:kick]).not_to be_active
        expect(steps[:snare]).not_to be_active
        expect(steps[:hihat]).not_to be_active
      end
    end
  end
end
