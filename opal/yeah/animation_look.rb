class Yeah::AnimationLook < Yeah::ImageLook
  class << self
    attr_accessor :width, :height

    def size
      [@width, @height]
    end

    def size=(value)
      @width, @height = value
    end
  end

  attr_reader :frame, :first_frame, :last_frame
  attr_accessor :width, :height

  def initialize
    super

    @width = self.class.width
    @height = self.class.height
    @frame = 0
    @first_frame = 0
    @last_frame = (@image.width / @width) * (@image.height / @height)
  end

  def size
    [@width, @height]
  end

  def size=(value)
    @width, @height = value
  end

  def draw(thing, display)
    x = @frame * @width % @image.width
    y = (@frame * @width / @image.width).floor * @height
    display.draw_image_part(@image, thing.x, thing.y, x, y, @width, @height)
    @frame += 1
    @frame = @first_frame if @frame >= @last_frame
  end
end
