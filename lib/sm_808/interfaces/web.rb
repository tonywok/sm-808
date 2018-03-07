require "json"
require "em-websocket"

module Sm808
  module Interfaces
    class Web < Interface
      attr_accessor :socket

      def on_start
        greeting
        EM.run do
          EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
            self.socket = ws
            ws.onclose { puts "Connection closed" }
            ws.onmessage { |msg| read_message(msg) }
          end
        end
      end

      def on_step(count, steps)
        send_message(
          command: "onStep",
          count: count,
          steps: steps.map { |kind, step| [kind, step.active?] }.to_h,
        )
      end

      private

      def read_message(msg)
        command = JSON.parse(msg)["command"]
        case command.to_sym
        when :play then play
        when :pause then pause
        else
          raise "command not supported"
        end
      end

      def send_message(msg)
        payload = JSON.generate(msg)
        socket.send(payload)
      end

      def play
        @play_timer = EM.add_periodic_timer(drum_machine.step_duration) do
          drum_machine.sample
        end
      end

      def pause
        return unless defined?(@play_timer)
        @play_timer.cancel
      end

      def greeting
        html_file = File.expand_path("web/index.html")
        puts "please point your browser to file://#{html_file}"
      end
    end
  end
end
