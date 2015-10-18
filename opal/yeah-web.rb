require 'opal'

module Yeah
  module Web
  end
end

require 'yeah/game'
require 'yeah/space'
require 'game'

Yeah::Game.subclasses.last.new
