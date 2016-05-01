class Yeah::Body
  class << self
    attr_accessor :offset_x, :offset_y

    def offset_x
      @offset_x ||= 0
    end

    def offset_y
      @offset_y ||= 0
    end

    def offset
      [@offset_x, @offset_y]
    end

    def offset=(value)
      @offset_x, @offset_y = value
    end
  end

  attr_accessor :thing, :offset_x, :offset_y

  def initialize(thing)
    @thing = thing
    @offset_x = self.class.offset_x
    @offset_y = self.class.offset_y
  end

  def x
    @thing.x + @offset_x
  end

  def y
    @thing.y + @offset_y
  end

  def position
    [@thing.x + @offset_x, @thing.y + @offset_y]
  end

  def offset
    [@offset_x, @offset_y]
  end

  def collide(other)
    return
  end
end
