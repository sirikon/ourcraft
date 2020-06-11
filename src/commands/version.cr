module Ourcraft::Commands
  extend self

  def version
    puts {{ `shards version`.strip.stringify }}
  end

end
