class Yeah::ImageLook < Yeah::Look
  class << self
    attr_accessor :image
  end

  attr_accessor :image

  def initialize(thing)
    super

    @image = self.class.image
  end

  def draw(display, elapsed)
    display.draw_image(image, x, y)
  end
end
