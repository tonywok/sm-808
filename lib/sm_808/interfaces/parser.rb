require "optparse"

module Sm808
  module Interfaces
    class Parser
      def self.parse(options)
        args = {
          interface: Sm808::Interfaces::Web
        }

        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: sm_808 [options]"

          opts.on("-t", "--title=TITLE", "Song title (default: Untitled)") do |t|
            args[:title] = t
          end

          opts.on("-b", "--bpm=BPM", "Output speed in 'beats per minute' (default: 60)") do |b|
            args[:bpm] = b.to_i
          end

          opts.on("-i", "--interface=INTERFACE", "Available output interfaces (default: curses)") do |i|
            interface_strategy = {
              "text" => Sm808::Interfaces::Text,
              "demo" => Sm808::Interfaces::Demo,
              "web" => Sm808::Interfaces::Web,
            }.fetch(i)
            args[:interface] = interface_strategy
          end

          opts.on("-l", "--loops", "Number of playback loops (default: 4)") do |l|
            args[:loops] = l
          end

          opts.on("-v", "--version", "Version of sm_808") do |v|
            puts Sm808::VERSION
            exit
          end

          opts.on("-h", "--help", "Prints this help") do
            puts opts
            exit
          end
        end

        opt_parser.parse!(options)
        args
      end
    end
  end
end
