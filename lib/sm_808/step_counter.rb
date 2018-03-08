module Sm808
  # The step counter is responsible for determing the next step
  # to be sampled.
  #
  class StepCounter
    attr_reader :duration

    DEFAULT_STEP_COUNT = 8

    def initialize
      self.current_step = 0
      self.sequence = build_sequence(DEFAULT_STEP_COUNT)
    end

    def next_step
      self.current_step = sequence.next
    end

    def end_of_bar?
      sequence.peek.zero? && !current_step.zero?
    end

    # Update our internal sequence to accomodate a newly
    # added pattern that is of greater length.
    #
    def resequence!(pattern_duration)
      return unless pattern_duration > duration

      sequence.peek.tap do |upcoming_step|
        upcoming_step = duration + 1 if end_of_bar?
        self.sequence = build_sequence(pattern_duration)
        fast_forward(upcoming_step)
      end
    end

    def rewind
      sequence.rewind
      self.current_step = sequence.peek
    end

    private

    attr_accessor :sequence, :current_step
    attr_writer :duration

    # Constructs a lazy enumerator and captures the step count
    # as the duration. Went back and forth about whether or not
    # I should just not make this cycle -- not having to think
    # about the cycle is nice.
    #
    def build_sequence(step_count)
      self.duration = step_count
      (0...duration).lazy.cycle
    end

    def fast_forward(destination_step)
      sequence.next until sequence.peek == destination_step
    end
  end
end
