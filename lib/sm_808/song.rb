require "sm_808/pattern"
require "sm_808/step_counter"

module Sm808
  class Song
    extend Forwardable

    attr_reader :title, :bpm, :patterns, :counter, :step_duration

    def initialize(title: "Untitled", bpm: 60)
      @title = title
      @bpm = bpm
      @patterns = Pattern.defaults
      @counter = StepCounter.new
      calculate_step_duration
    end

    def_delegators :@counter, :end_of_bar?, :current_step, :rewind

    def add_pattern(kind, steps)
      new_sample = Pattern.new(kind, steps)
      patterns[new_sample.kind] = new_sample
      counter.resequence!(new_sample.duration)
      calculate_step_duration
    end

    def sample
      count = counter.next_step
      patterns.map do |kind, sample|
        [kind, sample.step(count)]
      end.to_h
    end

    private

    attr_writer :step_duration

    # TODO: variable time signature
    def calculate_step_duration
      minute = 60.0
      beats_per_bar = 4
      self.step_duration = ((minute / bpm) * beats_per_bar) / counter.duration
    end
  end
end
