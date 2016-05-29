class Yeah::ColorRectangleLook < Yeah::Look
  class << self
    attr_accessor :width, :height, :color

    def size
      [@width, @height]
    end

    def size=(value)
      @width, @height = value
    end
  end

  attr_accessor :width, :height, :color

  def initialize(thing)
    super

    @width = self.class.width
    @height = self.class.height
    @color = self.class.color
  end

  def size
    [@width, @height]
  end

  def size=(value)
    @width, @height = value
  end

  def draw(display, elapsed)
    display.fill(color, x, y, width, height)
  end
end
