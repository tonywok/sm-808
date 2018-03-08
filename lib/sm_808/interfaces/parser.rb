require "optparse"

module Sm808
  module Interfaces
    # Super minimal command line parser using ruby's stdlib OptionParser
    #
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

          opts.on("-i", "--interface=INTERFACE", "Available output interfaces: cli, web (default)") do |i|
            interface_strategy = {
              "cli" => Sm808::Interfaces::Cli,
              "web" => Sm808::Interfaces::Web,
            }.fetch(i)
            args[:interface] = interface_strategy
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
