module Sm808
  # A pattern is a sequence of steps, either active or inactive for a particular sample.
  #
  class Pattern
    def self.defaults
      Samples::ALL.each_with_object({}) do |sample, patterns|
        patterns[sample] = Pattern.new(sample, InactiveStep::INDICATOR)
      end
    end

    attr_reader :sample, :steps

    def initialize(sample, step_indicators)
      @sample = sample
      @steps = add_steps(step_indicators)
    end

    def step(step_count)
      steps[step_count % duration]
    end

    def duration
      steps.length
    end

    # Updates the pattern's step at step index to be active/inactive
    # Attempts to update an out of bounds step will grow pattern to accomodate
    #
    def update_step(step_index, active)
      fill_to = (step_index + 1) - duration
      steps.fill(duration, fill_to) { InactiveStep.instance }
      steps[step_index] = step_for(active)
    end

    # Converts the handy string representation of step indicators into actual
    # steps.
    #
    def add_steps(step_indicators)
      self.steps = step_indicators.split("").map do |indicator|
        step_for_indicator(indicator)
      end
    end

    private

    attr_writer :steps

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
