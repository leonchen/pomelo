# pomelo-router
Linux router network setup hepler.


## Install

````
sudo gem install pomelo-router
````

## Usage
You will need a [toml](https://github.com/toml-lang/toml) config file to tell pomelo the network info and how you want the traffics to be. Checkout [Example Config](https://github.com/leonchen/pomelo/blob/master/config.toml.example) for more information.

````
# print all the generated commands, no running
pomelo -p -c path/to/config.toml

# run 
sudo pomelo -c path/to/config.toml
````
