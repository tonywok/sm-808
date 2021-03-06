require "json"
require "em-websocket"

module Sm808
  module Interfaces
    # Starts a websocket server to communicate with web client.
    #
    class Web < Interface
      extend Forwardable

      attr_accessor :socket

      def_delegator :@drum_machine, :song

      def initialize(*args)
        super
        self.paused = true
      end

      def on_start
        print_instructions
        EM.run do
          # Start websocket server
          EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
            self.socket = ws
            ws.onclose { puts "Connection closed" }
            ws.onmessage { |msg| read_message(msg) }
          end

          # Schedule sample playback
          EM.add_periodic_timer(drum_machine.step_duration) do
            drum_machine.sample unless paused?
          end
        end
      end

      def on_step(count, steps)
        send_message(
          command: "onStep",
          count: count,
          steps: steps.map { |sample, step| [sample, step.active?] }.to_h,
        )
      end

      private

      attr_accessor :paused
      alias_method :paused?, :paused

      def read_message(data)
        message = JSON.parse(data)
        command = message["command"]
        args = message["args"]

        case command.to_sym
        when :play then play
        when :pause then pause
        when :toggle_step then toggle_step(args)
        # TODO: update_sample_duration
        else
          raise "command: #{command} not supported"
        end
      end

      def send_message(msg)
        payload = JSON.generate(msg)
        socket.send(payload)
      end

      def toggle_step(args)
        pattern = song.pattern(args.fetch("sample"))
        pattern.update_step(
          args.fetch("step_index"),
          args.fetch("active"),
        )
      end

      def play
        self.paused = false
      end

      def pause
        self.paused = true
      end

      def print_instructions
        html_file = File.expand_path("web/index.html")
        puts "please point your browser to file://#{html_file}"
      end
    end
  end
end
