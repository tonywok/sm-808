module Sm808
  class Pattern
    module Kinds
      ALL = [
        KICK = :kick,
        SNARE = :snare,
        HIHAT = :hihat,
      ]
    end

    def self.defaults
      Kinds::ALL.each_with_object({}) do |kind, patterns|
        patterns[kind] = Pattern.new(kind, InactiveStep::INDICATOR)
      end
    end

    def self.active_step
      ActiveStep.instance
    end

    def self.inactive_step
      InactiveStep.instance
    end

    attr_reader :kind, :steps

    def initialize(kind, step_indicators)
      @kind = kind
      @steps = step_indicators.split("").map do |indicator|
        step_for_indicator(indicator)
      end
    end

    def step(step_count)
      steps[step_count % duration]
    end

    def duration
      steps.length
    end

    def update_step(step_index, active)
      fill_to = (step_index + 1) - duration
      steps.fill(duration, fill_to) { InactiveStep.instance }
      steps[step_index] = step_for(active)
    end

    private

    def step_for(active)
      if active
        ActiveStep.instance
      else
        InactiveStep.instance
      end
    end

    def step_for_indicator(indicator)
      case indicator
      when InactiveStep::INDICATOR then InactiveStep.instance
      when ActiveStep::INDICATOR then ActiveStep.instance
      else
        raise "unsupported indicator: #{indicator}"
      end
    end
  end
end
