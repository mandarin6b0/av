module Av
  class Cli
    attr_accessor :command

    def initialize(options)
      @command = Av::Commands::Ffmpeg.new(options)
    end

    protected
      def method_missing name, *args, &block
        @command.send(name, *args, &block)
      end

      def detect_command(command)
        command = "if command -v #{command} 2>/dev/null; then echo \"true\"; else echo \"false\"; fi"
        result = ::Av.run(command)
        case result
          when /true/
            return true
          when /false/
            return false
        end
      end
  end
end
