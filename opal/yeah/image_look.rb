require 'yeah/look'

class Yeah::ImageLook < Yeah::Look
  class << self
    attr_accessor :image
  end

  attr_accessor :image

  def initialize
    super

    self.image = self.class.image
  end

  def draw(thing, display)
    display.draw_image(image, thing.x, thing.y)
  end
end
