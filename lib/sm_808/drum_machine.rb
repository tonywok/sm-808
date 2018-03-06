require "sm_808/song"

module Sm808
  class DrumMachine
    extend Forwardable

    attr_reader :song, :interface

    def initialize(interface: Interfaces::Text.new, **kwargs)
      @song = Song.new(**kwargs)
      @interface = interface
      pause
    end

    def_delegators :@song, :bpm, :step_duration, :add_sample

    def playback
      playing do
        sample
      end
      interface.on_finish
    end

    def pause
      self.paused = true
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

    def sample
      steps = song.sample
      sleep step_duration unless interface.test?
      interface.on_step(song.current_step, steps)
      interface.on_bar if song.complete?
    end
  end
end
