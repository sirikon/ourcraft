module Ourcraft::Commands
  extend self

  def version
    puts {{ read_file("./VERSION").strip }}
  end

end
