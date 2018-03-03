module Sm808
  class Sample
    attr_reader :kind, :pattern

    ACTIVE_STEP = "X"

    def initialize(kind, pattern)
      @kind = kind
      @pattern = pattern.split("")
    end

    def active?(step_count)
      step = step_count % pattern.length
      pattern[step] == ACTIVE_STEP
    end
  end
end
