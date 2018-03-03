require_relative "formatters"

module Sm808
  class Song
    attr_reader :bpm, :title, :samples, :formatter

    def initialize(bpm: 128, title: "Untitled", formatter: Formatters::Text)
      @bmp = bpm
      @title = title
      @samples = {}
      @formatter = formatter.new(self)
    end

    def add_sample(sample)
      samples[sample.kind] = sample
    end

    def play
      next_step
      play
    rescue StopIteration
      formatter.fin
    end

    def next_step
      formatter.format(sequence.next)
    end

    private

    # TODO: push this into object responsible for sequencing
    def max_length
      pattern_lengths = samples.values.map { |s| s.pattern.length }
      pattern_lengths << 8
      pattern_lengths.max - 1
    end

    def sequence
      @sequence ||= (0..max_length).lazy
    end
  end
end
