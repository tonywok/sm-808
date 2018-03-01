module Sm808
  class Sample
    attr_reader :kind, :pattern

    def initialize(kind, pattern)
      @kind = kind
      @pattern = pattern.split("")
    end

    def active?(step)
      pattern[step] == "X"
    end
  end
end
