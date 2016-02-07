require 'opal'

module Yeah
  module Web
  end
end

require 'yeah/image'
require 'yeah/asset_loader'
require 'yeah/display'
require 'yeah/keyboard'
require 'yeah/mouse'
require 'yeah/game'
require 'yeah/space'
require 'yeah/thing'
require 'yeah/look'
require 'yeah/fill_look'
require 'yeah/image_look'
require 'yeah/sprite_look'

Yeah::AssetLoader.load_all do
  require 'game'

  Yeah::Game.subclasses.last.new
end
