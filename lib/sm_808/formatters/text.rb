module Sm808
  module Formatters
    class Text
      attr_reader :song, :output

      def initialize(song)
        @song = song
        @output = []
      end

      def format(step)
        sampled_step = song.samples.values.map do |sample|
          sample.active?(step) ? "X" : "0"
        end
        output << sampled_step
        sampled_step
      end

      #       +-----------------+
      # hat   |X|0|0|0|0|X|0|0|0|
      # kick  |0|0|0|0|0|0|0|0|0|
      # snare |0|0|X|0|X|0|0|X|0|
      #       +-----------------+
      def fin
        return if output.flatten.empty?
        out = output.transpose(&:reverse).inject(text_divider) do |str, row|
          str << "|"
          str << row.join("|")
          str << "|"
          str << "\n"
        end
        out += text_divider
        out
      end

      private

      def text_divider
        "+#{'-' * (output.length * 2 - 1)}+\n"
      end
    end
  end
end
