module Sm808
  module Interfaces
    class Interface
      attr_reader :drum_machine

      def initialize(drum_machine)
        @drum_machine = drum_machine
      end

      def on_start; end
      def on_step(step_count, steps); end
      def on_bar; end
      def on_finish; end

      def test?
        false
      end
    end
  end
end
