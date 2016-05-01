class Yeah::RectangleBody < Yeah::Body
  class << self
    attr_accessor :width, :height

    def size
      [@width, @height]
    end

    def size=(value)
      @width, @height = value
    end
  end

  attr_accessor :width, :height

  def initialize(thing)
    super

    @width = self.class.width
    @height = self.class.height
  end

  def x
    @thing.x + @offset_x
  end

  def y
    @thing.y + @offset_y
  end

  def size
    [@width, @height]
  end

  def size=(value)
    @width, @height = value
  end

  def right
    @thing.x + @offset_x + @width
  end

  def left
    @thing.x + @offset_x
  end

  def top
    @thing.y + @offset_y + @height
  end

  def bottom
    @thing.y + @offset_y
  end

  def collide(other, overlap_x, overlap_y)
    return
  end
end
