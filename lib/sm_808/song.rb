require "sm_808/step_sequence"

module Sm808
  class Song
    extend Forwardable

    attr_reader :title, :samples, :step_sequence

    def initialize(bpm: 60, title: "Untitled")
      @title = title
      @samples = default_samples
      @step_sequence = StepSequence.new(bpm)
    end

    def_delegator :@step_sequence, :complete?

    def play(num, &block)
      step_sequence.step_through(num) do |step|
        notes = sample(step)
        yield step, notes
      end
    end

    def add_sample(sample)
      samples[sample.kind] = sample
      step_sequence.resequence!(sample.duration)
    end

    def sample(step)
      samples.map { |kind, sample| [kind, sample.note(step)] }.to_h
    end

    private

    def default_samples
      Sample::Kinds::ALL.each_with_object({}) do |kind, samples|
        samples[kind] = Sample.new(kind, Sample::INACTIVE_STEP)
      end
    end
  end
end
