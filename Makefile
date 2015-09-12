b:
	gem build pomelo.gemspec

i: b
	gem install --local pomelo-router-0.0.2.gem

p: i
	gem push pomelo-router-0.0.2.gem
