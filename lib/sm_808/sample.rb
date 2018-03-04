require_relative "note"
require "singleton"

module Sm808
  class Sample
    ACTIVE_STEP = "X"
    INACTIVE_STEP = "0"

    module Kinds
      ALL = [
        KICK = :kick,
        SNARE = :snare,
        HIHAT = :hihat,
      ]
    end

    attr_reader :kind, :notes

    def initialize(kind, pattern)
      @kind = kind
      @notes = build_notes(pattern)
    end

    def note(step_count)
      notes[step_count % duration]
    end

    def duration
      notes.length
    end

    private

    def build_notes(pattern)
      pattern = INACTIVE_STEP if pattern.empty?
      pattern.split("").map do |indicator|
        Note.new(kind, indicator == ACTIVE_STEP)
      end
    end
  end
end
