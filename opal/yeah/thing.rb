class Yeah::Thing
  class << self
    attr_accessor :look
  end

  attr_reader :game
  attr_accessor :x, :y, :look

  def initialize(options)
    @look = self.class.look.new

    # Assign options.
    options.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  def position
    [x, y]
  end

  def position=(value)
    self.x, self.y = value
  end

  def act(elapsed)
    return
  end

  def collide(collision)
    return
  end

  protected

  def display
    game.display
  end

  def keyboard
    game.keyboard
  end

  def space
    game.space
  end
end
