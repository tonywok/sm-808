module Sm808
  class Song
    attr_reader :title, :samples

    def initialize(title: "Untitled")
      @title = title
      @samples = default_samples
    end

    def add_sample(sample)
      samples[sample.kind] = sample
    end

    def sample(step)
      samples.map { |kind, sample| [kind, sample.note(step)] }.to_h
    end

    private

    def default_samples
      Sample::Kinds::ALL.each_with_object({}) do |kind, samples|
        samples[kind] = Sample.new(kind, Sample::INACTIVE_STEP)
      end
    end
  end
end
