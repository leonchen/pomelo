b:
	gem build pomelo.gemspec

i: b
	gem install --local pomelo-router-0.0.1.gem
