Gem::Specification.new do |s|  
  s.name        = 'pomelo-router'
  s.version     = '0.0.2'
  s.licenses    = ["MIT"]
  s.executables << 'pomelo'
  s.date        = '2015-09-11'
  s.summary     = "pomelo-router"
  s.description = "linux router network setup automation"
  s.authors     = ["Leon Chen"]
  s.email       = 'leonhart.chen@gmail.com'
  s.files       = ["lib/pomelo.rb", "lib/pomelo/opts.rb", "lib/pomelo/parser.rb", "config.toml.example"]
  s.homepage    = "https://github.com/leonchen/pomelo"

  s.require_paths = ["lib"] 
  s.add_dependency "toml", "~> 0.1.2"
end  
