require 'yeah/look' #

class Yeah::FillLook < Yeah::Look
  class << self
    attr_accessor :width, :height, :color

    def size
      [width, height]
    end

    def size=(value)
      self.width, self.height = value
    end
  end

  attr_accessor :width, :height, :color

  def initialize
    self.width = self.class.width
    self.height = self.class.height
    self.color = self.class.color
  end

  def size
    [width, height]
  end

  def size=(value)
    self.width, self.height = value
  end

  def draw(thing, display)
    display.fill(thing.x, thing.y, width, height, color)
  end
end
