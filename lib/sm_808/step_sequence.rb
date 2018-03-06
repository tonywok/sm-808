module Sm808
  class StepSequence
    attr_reader :duration

    DEFAULT_STEP_COUNT = 8

    def initialize(bpm)
      self.current_step = 0
      self.bpm = bpm
      self.sequence = build_sequence(DEFAULT_STEP_COUNT)
    end

    def step_through(num = 1)
      num.times do
        duration.times { yield next_step }
        rewind
      end
    end

    def next_step
      self.current_step = sequence.next.tap do
        sleep(step_duration)
      end
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

    attr_accessor :sequence, :current_step, :step_duration, :bpm
    attr_writer :duration

    def build_sequence(step_count)
      self.duration = step_count
      self.step_duration = 60.0 / bpm * 4 / duration
      (0...duration).lazy.cycle
    end

    def fast_forward(destination_step)
      sequence.next until sequence.peek == destination_step
    end

    def rewind
      sequence.rewind
      self.current_step = sequence.peek
    end
  end
end
