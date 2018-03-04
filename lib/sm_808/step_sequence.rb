module Sm808
  class StepSequence
    attr_reader :duration

    def initialize(default_step_count: 8)
      self.current_step = 0
      self.sequence = build_sequence(default_step_count)
    end

    def next_step
      self.current_step = sequence.next
    end

    def complete?
      sequence.peek.zero? && !current_step.zero?
    end

    def resequence!(sample_duration)
      return unless sample_duration > duration

      sequence.peek.tap do |upcoming_step|
        upcoming_step = duration + 1 if complete?
        self.sequence = build_sequence(sample_duration)
        fast_forward(upcoming_step)
      end
    end

    private

    attr_accessor :sequence, :current_step
    attr_writer :duration

    def build_sequence(step_count)
      self.duration = step_count
      (0...duration).lazy.cycle
    end

    def fast_forward(destination_step)
      sequence.next until sequence.peek == destination_step
    end
  end
end
