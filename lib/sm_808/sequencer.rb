require_relative "formatters"

module Sm808
  class Sequencer
    def initialize(formatter: Formatters::Text)
      self.samples = {}
      self.formatter = formatter.new
    end

    def step
      formatter.format(active_samples)
    end

    def add(sample)
      samples[sample.kind] = sample
    end

    private

    attr_accessor :samples, :formatter

    def sequence
      @sequence ||= (0..7).cycle
    end

    def active_samples
      step_count = sequence.next
      samples.values.select do |s|
        s.active?(step_count)
      end
    end
  end
end
