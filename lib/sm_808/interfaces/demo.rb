module Sm808
  module Interfaces
    class Demo < Interface
      def on_step(step, notes)
        active_notes = notes.values.select(&:active?)

        print "|"
        if active_notes.empty?
          print "_"
        else
          print active_notes.map(&:kind).join("+")
        end
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
