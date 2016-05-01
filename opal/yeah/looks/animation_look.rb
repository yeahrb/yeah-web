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

  def initialize(thing)
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

  def draw(display, elapsed)
    part_x = @frame.floor * @width % @image.width
    part_y = (@frame.floor * @width / @image.width).floor * @height
    display.draw_image_part(@image, x, y, part_x, part_y, @width, @height)
    @frame += @rate * elapsed
    @frame = @first_frame if @frame >= @last_frame
  end
end
