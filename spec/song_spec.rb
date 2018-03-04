require "spec_helper"

RSpec.describe Sm808::Song do
  let(:song) { described_class.new }

  describe "#title" do
    it "defaults to untitled" do
      expect(song.title).to eq("Untitled")
    end
  end

  describe "#samples" do
    it "has all samples" do
      expect(song.samples.keys).to eq(Sample::Kinds::ALL)
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

      it "extracts the active notes from each sample" do
        notes = song.sample(0)
        expect(notes[:kick]).to be_active
        expect(notes[:snare]).not_to be_active
        expect(notes[:hihat]).not_to be_active
      end

      it "gracefully handles higher step counts" do
        notes = song.sample(10)
        expect(notes[:kick]).not_to be_active
        expect(notes[:snare]).not_to be_active
        expect(notes[:hihat]).to be_active
      end
    end

    context "no user defined samples" do
      it "only has inactive notes" do
        notes = song.sample(0)
        expect(notes[:kick]).not_to be_active
        expect(notes[:snare]).not_to be_active
        expect(notes[:hihat]).not_to be_active
      end
    end
  end
end
