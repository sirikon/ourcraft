module Ourcraft::Commands
  extend self

  def help
    print {{ read_file("#{__DIR__}/../assets/help") }}
  end

end
