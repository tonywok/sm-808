require "sm_808/song"

module Sm808
  # Orchestrates the playback and sampling of a song containing
  # sequenced patterns for a supported output interface.
  #
  class DrumMachine
    extend Forwardable

    attr_reader :song, :interface

    def initialize(interface:, **kwargs)
      @song = Song.new(**kwargs)
      @interface = interface.new(self)
    end

    def_delegators :@song, :bpm, :step_duration, :add_sample, :current_step

    def playback(num_loops = 1)
      num_loops.times do
        sample until song.end_of_bar?
        song.rewind
      end
      interface.on_finish
    end

    def sample
      steps = song.sample
      interface.on_step(current_step, steps)
      interface.on_bar if song.end_of_bar?
    end
  end
end
