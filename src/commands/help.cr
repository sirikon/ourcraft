module Ourcraft::Commands
  extend self

  def help
    print {{ read_file("./src/assets/help") }}
  end

end
