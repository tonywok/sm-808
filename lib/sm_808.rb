require "sm_808/version"
require "sm_808/interfaces"
require "sm_808/drum_machine"

require "singleton"

module Sm808
  module Samples
    ALL = [
      KICK = :kick,
      SNARE = :snare,
      HIHAT = :hihat,
    ]
  end

  class InactiveStep
    include Singleton

    INDICATOR = "0"

    def active?
      false
    end

    def indicator
      INDICATOR
    end
  end

  class ActiveStep
    include Singleton

    INDICATOR = "X"

    def active?
      true
    end

    def indicator
      INDICATOR
    end
  end
end
