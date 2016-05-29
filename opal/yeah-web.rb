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
require 'yeah/collisions/collisions'
require 'yeah/collisions/rectangle_collisions'
require 'yeah/game'
require 'yeah/spaces/space'
require 'yeah/spaces/tile_space'
require 'yeah/thing'
require 'yeah/looks/look'
require 'yeah/looks/color_rectangle_look'
require 'yeah/looks/image_look'
require 'yeah/looks/animation_look'
require 'yeah/looks/sprite_look'
require 'yeah/bodies/body'
require 'yeah/bodies/rectangle_body'

include Yeah

AssetLoader.load_all do
  require 'game'

  Game.subclasses.last.new
end
