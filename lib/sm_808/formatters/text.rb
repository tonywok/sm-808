module Sm808
  module Formatters
    class Text
      def format(active_samples)
        return "_" if active_samples.empty?
        active_samples.map(&:kind).join("+")
      end
    end
  end
end
