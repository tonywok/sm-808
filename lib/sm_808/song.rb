require "sm_808/pattern"
require "sm_808/step_counter"

module Sm808
  # A song is responsible for sequencing multiple patterns for different samples
  #
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

    def update_pattern(sample, step_indicators)
      pattern(sample).tap do |p|
        p.add_steps(step_indicators)
        counter.resequence!(p.duration)
        calculate_step_duration
      end
    end

    # Returns a hash of sample to patterns sequenced for the next step
    #
    def sample
      count = counter.next_step
      patterns.map do |sample, pattern|
        [sample, pattern.step(count)]
      end.to_h
    end

    def pattern(sample)
      patterns.fetch(sample.to_sym) do
        raise "sm808 doesn't yet support #{sample}"
      end
    end

    private

    attr_writer :step_duration

    # Pulling this out into a method since the step duration can change as a result of
    # the counter duration or BPM changing (e.g adding variable pattern durations)
    def calculate_step_duration
      minute = 60.0
      beats_per_bar = 4
      self.step_duration = ((minute / bpm) * beats_per_bar) / counter.duration
    end
  end
end
