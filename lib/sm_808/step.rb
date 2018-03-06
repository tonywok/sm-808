module Sm808
  class Step
    attr_reader :kind, :active

    ACTIVE = "X"
    INACTIVE = "0"

    def initialize(kind, active)
      @kind = kind
      @active = active
    end

    alias_method :active?, :active
  end
end
