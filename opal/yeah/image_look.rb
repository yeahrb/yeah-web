require 'yeah/look'

class Yeah::ImageLook < Yeah::Look
  class << self
    attr_accessor :image
  end

  attr_accessor :image

  def initialize
    self.image = self.class.image
  end

  def draw(thing, display)
    display.draw_image(thing.x, thing.y, image)
  end
end
