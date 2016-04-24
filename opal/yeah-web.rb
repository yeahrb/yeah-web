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
require 'yeah/looks/look'
require 'yeah/looks/fill_look'
require 'yeah/looks/image_look'
require 'yeah/looks/animation_look'
require 'yeah/looks/sprite_look'

include Yeah

AssetLoader.load_all do
  require 'game'

  Game.subclasses.last.new
end
