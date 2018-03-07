module Sm808
  module Interfaces
    # An output interface for implementing the cli demo.
    # Used this to keep me honest.
    #
    class Cli < Interface
      def on_start
        drum_machine.playback(4)
      end

      def on_step(count, steps)
        active_steps = steps.values.select(&:active?)

        print "|"
        if active_steps.empty?
          print "_"
        else
          print active_steps.map(&:kind).join("+")
        end

        sleep drum_machine.step_duration
      end

      def on_bar
        print "|\n"
      end

      def on_finish
        puts "Tune in later for more!"
      end
    end
  end
end
