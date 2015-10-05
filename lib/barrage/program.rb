require "thor"
require_relative "commandline"
require_relative "cpu"
require_relative "memory"
require_relative "network"

module Barrage
  class Program
    def self.run(argv)
      trap("INT") { Program.kill(Commandline.dstat_pid) }
      Commandline.start(argv)

      if argv.size > 0 && argv[0] != "--help"
        if !Dir.exist?('output')
          Dir.mkdir 'output'
        end

        $stdin.read
      end
    end

    def self.kill(pid)
      if pid > 0
        puts "#{pid}"
        Process.kill "QUIT", pid
      end

      puts "Plotting..."
      Commandline.plot(Commandline.dstat_file)
      Commandline.upload
      exit(0)
    end
  end
end