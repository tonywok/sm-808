require_relative "step"

module Sm808
  class Sample
    module Kinds
      ALL = [
        KICK = :kick,
        SNARE = :snare,
        HIHAT = :hihat,
      ]
    end

    def self.defaults
      Kinds::ALL.each_with_object({}) do |kind, samples|
        samples[kind] = Sample.new(kind, Step::INACTIVE)
      end
    end

    attr_reader :kind, :steps

    def initialize(kind, pattern)
      @kind = kind
      @steps = build_steps(pattern)
    end

    def step(step_count)
      steps[step_count % duration]
    end

    def duration
      steps.length
    end

    private

    def build_steps(pattern)
      pattern = Step::INACTIVE if pattern.empty?
      pattern.split("").map do |indicator|
        Step.new(kind, indicator == Step::ACTIVE)
      end
    end
  end
end
