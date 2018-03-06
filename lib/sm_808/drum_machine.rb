require "sm_808/song"
require "sm_808/sample"

module Sm808
  class DrumMachine
    attr_reader :bpm, :loops, :song, :step_sequence, :interface

    def initialize(bpm: 60, loops: 4, title: "Unititled", interface: Interfaces::Text.new)
      @loops = loops
      @song = Song.new(bpm: bpm, title: title)
      @interface = interface
    end

    def playback
      interface.on_start

      song.play(loops) do |step, notes|
        interface.on_step(step, notes)
        interface.on_bar if song.complete?
      end

      interface.on_finish
    end

    def add_sample(sample)
      song.add_sample(sample)
    end
  end
end
