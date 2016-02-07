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

  attr_reader :animation, :frames, :frame
  attr_accessor :width, :height

  def initialize
    super

    @width = self.class.width
    @height = self.class.height
    self.animation = self.class.animations.keys.first
  end

  def size
    [width, height]
  end

  def size=(value)
    self.width, self.height = value
  end

  def animation=(value)
    @frames = self.class.animations[value]

    if @frames.respond_to? :keys
      @frames = @frames[:frames]
    end

    if @frames.respond_to? :to_a
      @frames = @frames.to_a
    else
      @frames = [@frames]
    end

    @frame = @frames.first
    @animation = value
  end

  def draw(thing, display)
    x = @frame * @width % @image.width
    y = (@frame * @width / @image.width).floor * @height
    display.draw_image_part(@image, thing.x, thing.y, x, y, @width, @height)
    @frame += 1
    @frame = @frames.first if @frame >= @frames.last
  end
end
