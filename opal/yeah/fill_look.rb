class Yeah::FillLook < Yeah::Look
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

  def initialize
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

  def draw(thing, display, elapsed)
    display.fill(color, thing.x, thing.y, width, height)
  end
end
