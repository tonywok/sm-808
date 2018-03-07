require "sm_808/song"

module Sm808
  class DrumMachine
    extend Forwardable

    attr_reader :song, :interface, :queue

    def initialize(interface: Interfaces::Text, **kwargs)
      @song = Song.new(**kwargs)
      @interface = interface.new(self)
    end

    def_delegators :@song, :bpm, :step_duration, :add_sample

    def playback
      playing do
        sample
      end
      interface.on_finish
    end

    def sample
      steps = song.sample
      interface.on_step(song.current_step, steps)
      interface.on_bar if song.complete?
    end

    private

    attr_accessor :paused
    alias_method :paused?, :paused

    def playing
      self.paused = false
      until paused? || song.complete?
        yield
      end
    end
  end
end
