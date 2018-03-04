require "singleton"

module Sm808
  class Note
    attr_reader :kind, :active

    def initialize(kind, active)
      @kind = kind
      @active = active
    end

    alias_method :active?, :active
  end
end
