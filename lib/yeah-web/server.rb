require 'rack'
require 'opal'

class Yeah::Web::Server
  def initialize(port = 1234)
    Rack::Server.start(
      app: Opal::Server.new { |s|
        s.append_path File.expand_path("../../../opal", __FILE__)
        s.main = 'yeah-web'
        s.index_path = File.expand_path("../container.html.erb", __FILE__)
        s.append_path 'src'
        s.append_path 'assets'
      },
      Port: port
    )
  end
end
