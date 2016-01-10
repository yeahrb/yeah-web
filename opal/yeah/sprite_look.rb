require 'yeah/image_look'

class Yeah::SpriteLook < Yeah::ImageLook
  class << self
    attr_accessor :width, :height, :animations

    def size
      [width, height]
    end

    def size=(value)
      self.width, self.height = value
    end
  end

  attr_reader :frame
  attr_accessor :width, :height, :animation

  def initialize
    super

    @width = self.class.width
    @height = self.class.height
    @frame = 0
  end

  def size
    [width, height]
  end

  def size=(value)
    self.width, self.height = value
  end

  def draw(thing, display)
    x = @frame * @width % 576
    y = (@frame * @width / 576).floor * @height
    display.draw_image_part(@image, thing.x, thing.y, x, y, @width, @height)
    @frame += 1
    @frame = 0 if @frame >= (576 / @width) * (256 / @height)
  end
end
