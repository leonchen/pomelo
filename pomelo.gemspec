Gem::Specification.new do |s|  
  s.name        = 'pomelo'
  s.version     = '0.0.1'
  s.licenses    = ["MIT"]
  s.executables << 'pomelo'
  s.date        = '2015-09-11'
  s.summary     = "pomelo"
  s.description = "router network setup automation"
  s.authors     = ["Leon Chen"]
  s.email       = 'leonhart.chen@gmail.com'
  s.files       = ["lib/pomelo.rb", "lib/pomelo/opts.rb", "lib/pomelo/parser.rb"]
  s.require_paths = ["lib"] 
  s.homepage    = 'http://rubygems.org/gems/pomelo'
  # dependencies
  s.add_dependency "toml", "~> 0.1.2"
end  
