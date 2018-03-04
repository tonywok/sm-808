module Sm808
  module Interfaces
    class Text
      attr_reader :output

      def initialize
        @output = []
      end

      def play_step(step, notes)
        sampled_step = Sample::Kinds::ALL.map do |kind|
          notes[kind].active? ? "X" : "0"
        end
        output << sampled_step
        sampled_step
      end

      # +-----------------+
      # |X|0|0|0|0|X|0|0|0|
      # |0|0|0|0|0|0|0|0|0|
      # |0|0|X|0|X|0|0|X|0|
      # +-----------------+
      def on_finish
        divider = text_divider(output.length)
        out = output.transpose(&:reverse).inject(divider) do |str, row|
          str << "|"
          str << row.join("|")
          str << "|"
          str << "\n"
        end
        out += text_divider(output.length)
        out
      end

      private

      def text_divider(length)
        "+#{'-' * (length * 2 - 1)}+\n"
      end
    end
  end
end
