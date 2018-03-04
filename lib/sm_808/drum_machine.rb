require "sm_808/song"
require "sm_808/step_sequence"
require "sm_808/sample"

module Sm808
  class DrumMachine
    attr_reader :bpm, :song, :step_sequence, :interface

    def initialize(bpm: 60, title: "Unititled", interface: Interfaces::Text.new)
      @bpm = bpm
      @song = Song.new(title: title)
      @step_sequence = StepSequence.new
      @interface = interface
    end

    def playback
      until step_sequence.complete?
        step = step_sequence.next_step
        notes = song.sample(step)
        interface.play_step(step, notes)
      end
      interface.on_finish
    end

    def add_sample(sample)
      song.add_sample(sample)
      step_sequence.resequence!(sample.duration)
    end
  end
end
