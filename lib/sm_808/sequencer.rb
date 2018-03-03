module Sm808
  class Sequencer
    attr_accessor :step_count

    def intialize(step_count: 8)
      @step_count = step_count
    end

    def resequence!(new_sample)
      return unless new_sample.pattern.length > step_count
      self.step_count = new_sample.pattern
    end

    private

    def sequence
      @sequence ||= (0..step_count).lazy
    end
  end
end
