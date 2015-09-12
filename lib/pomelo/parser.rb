require 'toml'

module Pomelo
  class Parser
    def initialize(opts)
      @opts = opts
      @commands = []

      @config = get_config
    end

    def parse
      parse_routes
      parse_iptables
    end

    def run
      parse
      run_commands = @commands.join("\n")
      if print_only?
        puts run_commands
      else
        system run_commands
      end
    end

    private

    def print_only?
      return @opts.mode == "print"
    end

    def get_config
      config_file = @opts.config_file
      unless config_file
        puts "config file required"
        exit
      end

      begin
        config = TOML.load_file(config_file)
      rescue Exception => e
        puts e
        puts e.backtrace.join("\n")
        exit
      end

      return config
    end

    def parse_routes
    end

    def parse_iptables
      init_iptables
      open_ports
      traffic_rules
    end

    def add_command(cmd)
      @commands << cmd
    end

    def get_value(key)
      parts = key.split "."
      c = @config
      parts.each do |p|
        c = c[p]
      end

      # parsing quotes 
      c = parse_value(c) if c.is_a?(String)

      return c
    end

    def parse_value(str)
      return str.gsub(/\#\{([^\}]+)\}/) do |s|
        a = s.gsub(/[\#\{\}]/, "")
        return get_value(a)
      end
    end

    def init_iptables
      s = get_value("traffic.global") == "allow" ? "ACCEPT" : "DROP"
      lo = get_value("networks.loopback")
      add_command "iptables -F" 
      add_command "iptables -P INPUT #{s}"    
      add_command "iptables -P OUTPUT #{s}"    
      add_command "iptables -P FORWARD #{s}" 
      # allow loopback
      add_command "iptables -A INPUT -i #{lo} -j ACCEPT"
      add_command "iptables -A OUTPUT -o #{lo} -j ACCEPT"
      # allow ping
      if get_value("networks.allow_icmp")
        add_command "iptables -A INPUT -p icmp -j ACCEPT"
        add_command "iptables -A OUTPUT -p icmp -j ACCEPT"
      end
    end

    def open_ports
      get_value("ports").each do |p|
        add_command "iptables -A INPUT -i #{p["dev"]} -p #{p["protocol"]} --dport #{p["port"]} -j ACCEPT"
        add_command "iptables -A OUTPUT -o #{p["dev"]} -p #{p["protocol"]} --sport #{p["port"]} -j ACCEPT"
      end
    end

    def traffic_rules
      get_value("rules").each do |r|
        parse_rule(r)
      end
    end

    def parse_rule(r)
      method = r["method"]
      if method == "gateway"
        parse_gateway_rule(r)
      elsif method == "forward"
        parse_forward_rule(r)
      end
    end

    def parse_gateway_rule(r)
      from = parse_value(r["from"])
      to = parse_value(r["to"])
      source = nil

      if from["host"]
        source = "-s #{from["host"]}"
      elsif from["net"]
        source = "-s #{from["net"]}"
      elsif from["range"]
        source = "-m iprange --src-range #{from["range"]}"
      else
        raise "from must contain host or range"
      end

      add_command "iptables -t nat -A POSTROUTING #{source} -o #{to["dev"]} -j MASQUERADE"
    end

    def parse_forward_rule(r)
      from = r["from"]
      protocol = r["protocol"] || "tcp"
      # forward requires host for destination
      to_host, to_port = parse_value(r["to"]).split(":")
      if to_port
        to = "#{to_host}:#{to_port}"
      else
        to_port = from
        to = to_host
      end

      add_command "iptables -t nat -A PREROUTING -p #{protocol} --dport #{from} -j DNAT --to #{to}"
      add_command "iptables -A FORWARD -p #{protocol} -d #{to_host} --dport #{to_port} -j ACCEPT"
    end

  end
end
