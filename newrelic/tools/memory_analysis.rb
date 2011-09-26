require "rubinius/agent"

agent = Rubinius::Agent.loopback

agent.request :set_config, "system.memory.dump", "before.dump"

array = (0..10).map { |i| "x" * rand(i) }
p array

agent.request :set_config, "system.memory.dump", "after.dump"

