module Sm808
  module Interfaces
    class Text < Interface
      attr_reader :output

      def initialize(drum_machine)
        super
        @output = []
      end

      def on_step(step, notes)
        sampled_step = Sample::Kinds::ALL.map do |kind|
          notes[kind].active? ? "X" : "0"
        end
        output << sampled_step
        sampled_step
      end

      #       +-----------------+
      # kick  |X|0|0|0|0|X|0|0|0|
      # snare |0|0|0|0|0|0|0|0|0|
      # hihat |0|0|X|0|X|0|0|X|0|
      #       +-----------------+
      def on_finish
        padding = 6
        divider = text_divider(output.length, padding)
        out = output.transpose(&:reverse).each.with_object(divider).with_index do |(row, str), i|
          str << Sample::Kinds::ALL[i].to_s.ljust(padding)
          str << "|"
          str << row.join("|")
          str << "|"
          str << "\n"
        end
        out += text_divider(output.length, padding)
        out
      end

      def test?
        true
      end

      private

      def text_divider(length, pad)
        " " * pad + "+#{'-' * (length * 2 - 1)}+\n"
      end
    end
  end
end
