class Yeah::AnimationLook < Yeah::ImageLook
  class << self
    attr_accessor :width, :height, :rate

    def size
      [@width, @height]
    end

    def size=(value)
      @width, @height = value
    end
  end

  attr_reader :frame, :first_frame, :last_frame
  attr_accessor :width, :height, :rate

  def initialize
    super

    @width = self.class.width
    @height = self.class.height
    @frame = 0
    @first_frame = 0
    @last_frame = (@image.width / @width) * (@image.height / @height)
    @rate = self.class.rate || 60
  end

  def size
    [@width, @height]
  end

  def size=(value)
    @width, @height = value
  end

  def draw(thing, display, elapsed)
    x = @frame.floor * @width % @image.width
    y = (@frame.floor * @width / @image.width).floor * @height
    display.draw_image_part(@image, thing.x, thing.y, x, y, @width, @height)
    @frame += @rate * elapsed
    @frame = @first_frame if @frame >= @last_frame
  end
end
