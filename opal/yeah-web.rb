require 'opal'

module Yeah
  module Web
  end
end

require 'yeah/asset_loader'
require 'yeah/game'

Yeah::AssetLoader.load_all do
  require 'game'

  Yeah::Game.subclasses.last.new
end
