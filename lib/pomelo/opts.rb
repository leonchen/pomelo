require 'optparse'
require 'optparse/time'
require 'ostruct'

module Pomelo
class Opts
  def self.parse(args)
    options = OpenStruct.new
    options.mode = "run"
    options.config_file = nil

    opt = OptionParser.new do |opts|
      opts.banner = "Usage: pomelo [-rp] path/to/config.yaml"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-r", "--run", "run commands") do
        options.mode = "run"
      end
      opts.on("-p", "--print", "print commands") do
        options.mode = "print"
      end
      opts.on("-c", "--configi [PATH]", String, "config file path") do |f|
        options.config_file = f
      end

      opts.separator ""
      opts.separator "Common options:"
      opts.on_tail("-h", "--help", "Show help message") do
        puts opts
        exit
      end
    end

    opt.parse!(args)
    return options
  end
end
end
