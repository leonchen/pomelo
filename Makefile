b:
	gem build pomelo.gemspec

i: b
	gem install --local pomelo-0.0.1.gem
