module Sm808
  module Interfaces
    # To be used in tandem with a drum machine as
    # an output interface.
    #
    class Interface
      attr_reader :drum_machine

      def initialize(drum_machine)
        @drum_machine = drum_machine
      end

      # Hook to perform any initial startup commands
      #
      def on_start; end

      # Indicate the sampling of a step within the song
      #
      def on_step(step_count, steps); end

      # Indicate the completion of a bar within the song
      #
      def on_bar; end

      # Indicate the completion of a song's playback
      #
      def on_finish; end
    end
  end
end
