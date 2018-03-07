module Sm808
  module Interfaces
    # An interface used by the drum machine specs.
    # It doesn't implement any timing so to not block spec running.
    #
    class Test < Interface
      attr_reader :output

      def initialize(drum_machine)
        super
        @output = []
      end

      # Collect samples for a given step to be displayed upon completion of song
      #
      def on_step(_step_count, steps)
        sampled_steps = Sample::Kinds::ALL.map do |kind|
          steps[kind].active? ? Step::ACTIVE : Step::INACTIVE
        end
        output << sampled_steps
      end

      # Outputs a simple ascii diagram for easy assertion
      #
      #       +-----------------+
      # kick  |X|0|0|0|0|X|0|0|0|
      # snare |0|0|0|0|0|0|0|0|0|
      # hihat |0|0|X|0|X|0|0|X|0|
      #       +-----------------+
      def on_finish
        left_padding = 6
        divider = text_divider(output.length, left_padding)
        out = output.transpose(&:reverse).each.with_object(divider).with_index do |(row, str), i|
          str << Sample::Kinds::ALL[i].to_s.ljust(left_padding)
          str << "|"
          str << row.join("|")
          str << "|"
          str << "\n"
        end
        out += text_divider(output.length, left_padding)
        out
      end

      private

      # +--...---+
      #
      def text_divider(length, pad)
        " " * pad + "+#{'-' * (length * 2 - 1)}+\n"
      end
    end
  end
end
