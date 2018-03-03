require "spec_helper"

RSpec.describe Sm808::Song do
  let(:song) { described_class.new }

  describe "#next_step" do
    context "with no samples" do
      it "loops with no samples" do
        8.times { expect(song.next_step).to eq([]) }
      end
    end

    context "with samples" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "0000X000") }
      let(:hihat) { Sample.new(:hihat, "00X000X0") }

      before do
        song.add_sample(kick)
        song.add_sample(snare)
        song.add_sample(hihat)
      end

      it "sequences the samples" do
        expect(song.next_step).to eq(["X", "0", "0"])
        expect(song.next_step).to eq(["0", "0", "0"])
        expect(song.next_step).to eq(["0", "0", "X"])
        expect(song.next_step).to eq(["0", "0", "0"])
        expect(song.next_step).to eq(["X", "X", "0"])
        expect(song.next_step).to eq(["0", "0", "0"])
        expect(song.next_step).to eq(["0", "0", "X"])
        expect(song.next_step).to eq(["0", "0", "0"])
      end
    end

    context "with sample added midway through" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "0XXX0XXX") }

      before { song.add_sample(kick) }

      it "adds starts playing on the next step" do
        expect(song.next_step).to eq(["X"])
        expect(song.next_step).to eq(["0"])
        song.add_sample(snare)
        expect(song.next_step).to eq(["0", "X"])
        expect(song.next_step).to eq(["0", "X"])
        expect(song.next_step).to eq(["X", "0"])
        expect(song.next_step).to eq(["0", "X"])
        expect(song.next_step).to eq(["0", "X"])
        expect(song.next_step).to eq(["0", "X"])
      end
    end
  end

  describe "#play" do
    context "with no samples" do
      it "finishes immediately" do
        expect(song.play).to be_nil
      end
    end

    context "with samples that have the same pattern length" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "0XXX0XXX") }

      before do
        song.add_sample(kick)
        song.add_sample(snare)
      end

      it "sequences both" do
        expect(song.play).to eq(<<~TXT)
          +---------------+
          |X|0|0|0|X|0|0|0|
          |0|X|X|X|0|X|X|X|
          +---------------+
        TXT
      end
    end

    context "with samples of varying pattern length" do
      let(:kick)  { Sample.new(:kick,  "X000X000") }
      let(:snare) { Sample.new(:snare, "000X00000000X000") }
      let(:hihat) { Sample.new(:hihat, "0X") }

      before do
        song.add_sample(kick)
        song.add_sample(snare)
        song.add_sample(hihat)
      end

      it "sequences both, restarting the shorter sample" do
        expect(song.play).to eq(<<~TXT)
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
