require 'pomelo/opts'
require 'pomelo/parser'

module Pomelo
  def Pomelo.from_argv(argv)
    opts = Opts.parse(argv)
    return Parser.new(opts)
  end
end
